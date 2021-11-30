
#==========================WELCOME TO FT_SERVICES==============================

echo "\n\n\n\n
███████╗████████╗     ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
██╔════╝╚══██╔══╝     ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
█████╗     ██║        ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
██╔══╝     ██║        ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
██║        ██║███████╗███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗███████║
╚═╝        ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝
																	 (by hcanon)
																				  \n\n"
#=============================Cleaning workspace===============================


echo "\n\n\nDeleting potential previous Minikube...\n\n"

kubectl delete --all deployments
kubectl delete --all pods
kubectl delete --all services
kubectl delete --all pvc

minikube stop
minikube delete


#=============================Setting up minikube==============================


echo "\n\nStarting minikube...\n\n"

minikube start --vm-driver=docker --cpus=2 --memory=2000 --extra-config=apiserver.service-node-port-range=1-35000

minikube addons enable metallb
minikube addons enable metrics-server
minikube addons enable dashboard


#==========================Linking Minikube && Docker==========================


#-----connecting minikube to the future docker images
eval $(minikube docker-env)


#-----getting IP address
IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)


#============================Building up the images============================


echo "\n\nBuilding up docker images...\n\n"

docker build -t service_nginx ./srcs/nginx
docker build -t service_ftps --build-arg IP=${IP} ./srcs/ftps
docker build -t service_mysql ./srcs/mysql --build-arg IP=${IP}
docker build -t service_wordpress ./srcs/wordpress --build-arg IP=${IP}
docker build -t service_phpmyadmin ./srcs/phpmyadmin --build-arg IP=${IP}
docker build -t service_influxdb ./srcs/influxdb
docker build -t service_grafana ./srcs/grafana


#=============================Installing MetalLB===============================


echo "\n\nChanging kubectl config...\n\n"

kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
sed -e "s/mode: \"\"/mode: \"ipvs\"" | \
kubectl apply -f - -n kube-system


echo "\n\nInstalling MetalLB and load balancer...\n\n"

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"


#=============================Creating Pods===================================


echo "\n\nCreating pods and services...\n\n"
kubectl apply -f ./srcs/nginx.yaml
kubectl apply -f ./srcs/ftps.yaml
kubectl apply -f ./srcs/mysql.yaml
kubectl apply -f ./srcs/influxdb.yaml
kubectl apply -f ./srcs/wordpress.yaml
kubectl apply -f ./srcs/phpmyadmin.yaml
kubectl apply -f ./srcs/grafana.yaml
kubectl apply -f ./srcs/metallb.yaml

#=============================Optional===================================
###Test SSH
#echo "\n\nTesting SSH...\n"
#ssh admin@$(minikube ip) -p 22

###Crash Container
#echo "\n\nTesting Container Crash...\n"
#kubectl exec -it $(kubectl get pods | grep service_mysql | cut -d" " -f1) -- /bin/sh -c "kill 1"

###Export/Import Files from containers
#echo "\n\nExporting files from containers\n"
#kubectl cp srcs/grafana/grafana.db default/$(kubectl get pods | grep service_grafana | cut -d" " -f1):/var/lib/grafana/grafana.db

#=============================Getting live !===================================

echo "\n\n\nOpen your browser and enter the IP address !"
printf "\nThe minikube IP is: ${IP}\n\n"

echo "\n\nLaunching dashboard and browser...\n\n"
minikube dashboard
