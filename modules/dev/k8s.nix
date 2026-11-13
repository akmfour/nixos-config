{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.dev.k8s;
in
{
  options.dev.k8s = {
    enable = lib.mkEnableOption "Kubernetes client tools (kubectl, helm, kind, k3d, ...)" // {
      default = true;
    };
    k3s.enable = lib.mkEnableOption "a local single-node k3s server";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        kubectl
        kubernetes-helm
        kustomize
        k9s
        kubectx
        kind # needs dev.docker
        k3d # needs dev.docker
      ];
    })

    (lib.mkIf cfg.k3s.enable {
      services.k3s = {
        enable = true;
        role = "server";
      };
      # Pod / service traffic must not be dropped by the host firewall.
      networking.firewall.trustedInterfaces = [
        "cni0"
        "flannel.1"
      ];
      # Admin kubeconfig: /etc/rancher/k3s/k3s.yaml (root only). Use
      # `sudo k3s kubectl ...` or copy it to ~/.kube/config.
    })
  ];
}
