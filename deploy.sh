# Build and tag our images:
docker build -t rhysgoehring/multi-client:latest -t rhysgoehring/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t rhysgoehring/multi-server:latest -t rhysgoehring/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t rhysgoehring/multi-worker:latest -t rhysgoehring/multi-worker:$SHA -f ./worker/Dockerfile ./worker
# Push our images to docker hub:
docker push rhysgoehring/multi-client:latest
docker push rhysgoehring/multi-server:latest
docker push rhysgoehring/multi-worker:latest

docker push rhysgoehring/multi-client:$SHA
docker push rhysgoehring/multi-server:$SHA
docker push rhysgoehring/multi-worker:$SHA
# Apply all configs in the k8s directory:
kubectl apply -f k8s
# Imperatively set latest images on each deployment
kubectl set image deployments/server-deployment server=rhysgoehring/multi-server:$SHA
kubectl set image deployments/client-deployment client=rhysgoehring/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=rhysgoehring/multi-worker:$SHA