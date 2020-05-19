#!/bin/bash

# declare your project name here and then create a <project>.yaml file in the same directory
declare -a projects=("myproject")

for p in "${projects[@]}"
do
echo "Creating ArgoCD application for '$p'"
cat <<EOF | kubectl apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: $p
  namespace: argocd
spec:
  project: default
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - Validate=true
  source:
    repoURL: https://github.com/musabmasood/gitops-main.git
    targetRevision: HEAD
    path: argocd/helm-bootstrap-projects
    helm:
      valueFiles:
      - ../$p.yaml
EOF
done
