# helm

---

## Reference
- [creating-helm-repository-using-github-pages](https://www.opcito.com/blogs/creating-helm-repository-using-github-pages)

## Update helm charts
- after update helm charts, run below command to update index.yaml
  ```
  ./helm-generate.sh
  ```

## Install helm charts
- Add bitgin helm repo
  ```
  helm repo add bitgin https://bitgin.github.io/helm
  ```
- To check your repository Helm charts and its versions, use:
  ```
  helm search repo <chart-name>
  ```
- Install this Helm chart into your cluster
  ```
  helm install <release-name> bitgin/<chart-name> -f customize-values.yaml
  ```