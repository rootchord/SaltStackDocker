REGISTRY_NAME = telekomaustria
IMAGE_MASTER = salt-master
IMAGE_MINION = salt-minion
TAG_MASTER = 0.0.1
TAG_MINION = centos7
IMAGE_REF_MASTER = $(REGISTRY_NAME)/$(IMAGE_MASTER):$(TAG_MASTER)
IMAGE_REF_MINION = $(REGISTRY_NAME)/$(IMAGE_MINION):$(TAG_MINION)

K8S_DEFINITION_MASTER = ./openshift/salt-master-deployment.yaml
K8S_DEFINITION_MINION = ./openshift/salt-minion-deployment.yaml

NAMESPACE = salt
REPLICA_MASTER = 1
REPLICA_MINION = 5

#
# Docker targets
#
build-master:
	docker build -t $(IMAGE_MASTER):$(TAG_MASTER) ./salt-master/.
	docker build -t $(IMAGE_MASTER):latest ./salt-master/.
	docker tag $(IMAGE_MASTER):$(TAG_MASTER) $(REGISTRY_NAME)/$(IMAGE_MASTER):$(TAG_MASTER)
	docker tag $(IMAGE_MASTER):$(TAG_MASTER) $(REGISTRY_NAME)/$(IMAGE_MASTER):latest

build-minion:
	docker build -t $(IMAGE_MINION):$(TAG_MINION) ./salt-minion/.
	docker build -t $(IMAGE_MINION):latest ./salt-minion/.
	docker tag $(IMAGE_MINION):$(TAG_MINION) $(REGISTRY_NAME)/$(IMAGE_MINION):$(TAG_MINION)
	docker tag $(IMAGE_MINION):$(TAG_MINION) $(REGISTRY_NAME)/$(IMAGE_MINION):latest

push-master:
	docker push $(REGISTRY_NAME)/$(IMAGE_MASTER):$(TAG_MASTER)
	docker push $(REGISTRY_NAME)/$(IMAGE_MASTER):latest

push-minion:
	docker push $(REGISTRY_NAME)/$(IMAGE_MINION):$(TAG_MINION)
	docker push $(REGISTRY_NAME)/$(IMAGE_MINION):latest


#
# OpenShift targets
#
deploy-all: deploy-master deploy-minion
undeploy-all: undeploy-master undeploy-minion

deploy-master:
	@oc apply -n $(NAMESPACE) -f ./openshift/salt-master-service.yaml; \
	sed 's|@@IMAGE_REF@@|$(IMAGE_REF_MASTER)|g' $(K8S_DEFINITION_MASTER) \
		| sed 's|@@NAMESPACE@@|$(NAMESPACE)|g' \
		| sed 's|@@REPLICA_COUNT@@|$(REPLICA_MASTER)|g' \
		| oc apply -f  -

undeploy-master:
	@oc apply -n $(NAMESPACE) -f ./openshift/salt-master-service.yaml; \
	sed 's|@@IMAGE_REF@@|$(IMAGE_REF_MASTER)|g' $(K8S_DEFINITION_MASTER) \
		| sed 's|@@NAMESPACE@@|$(NAMESPACE)|g' \
		| sed 's|@@REPLICA_COUNT@@|$(REPLICA_MASTER)|g' \
		| oc delete -f  -

deploy-minion:
	sed 's|@@IMAGE_REF@@|$(IMAGE_REF_MINION)|g' $(K8S_DEFINITION_MINION) \
		| sed 's|@@NAMESPACE@@|$(NAMESPACE)|g' \
		| sed 's|@@REPLICA_COUNT@@|$(REPLICA_MINION)|g' \
		| oc apply -f  -

undeploy-minion:
	sed 's|@@IMAGE_REF@@|$(IMAGE_REF_MINION)|g' $(K8S_DEFINITION_MINION) \
		| sed 's|@@NAMESPACE@@|$(NAMESPACE)|g' \
		| sed 's|@@REPLICA_COUNT@@|$(REPLICA_MINION)|g' \
		| oc delete -f  -

exec-master:
	oc exec -it -n $(NAMESPACE) `oc get pods -n $(NAMESPACE) | grep salt-master | awk '{print $1}'` -- /bin/bash
