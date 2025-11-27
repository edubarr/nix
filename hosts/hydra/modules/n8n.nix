{ config, pkgs, ... }:
{
  services.n8n = {
    enable = true;
    openFirewall = true;
    environment = {
      WEBHOOK_URL = "https://n8n.edubarr.dev";
      N8N_HOST = "https://n8n.edubarr.dev";
    };
  };
}