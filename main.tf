#########################
# Locals (estandarizados)
#########################
locals {
  private_tags = {
    "hidden-deploy" = "curated"
  }

  standard_tags = {
    entity        = var.entity
    environment   = lower(var.environment)
    app_name      = var.app_name
    cost_center   = var.cost_center
    tracking_code = var.tracking_code
  }

  tags          = merge(local.standard_tags, local.private_tags, var.custom_tags)
  tags_inherited = merge(data.azurerm_resource_group.rsg_principal.tags, local.private_tags, local.standard_tags, var.custom_tags)

  effective_tags = var.inherit ? local.tags_inherited : local.tags

  vnet_enabled = var.enable_vnet_integration
}

data "azurerm_resource_group" "rsg_principal" {
  name = var.rsg_name
}

#########################
# Validaciones “soft” via preconditions
#########################
resource "azurerm_api_management" "apim" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rsg_principal.name

  publisher_name  = var.publisher_name
  publisher_email = var.publisher_email

  sku_name = var.sku_name

  # VNet (solo si habilitado)
  dynamic "virtual_network_configuration" {
    for_each = local.vnet_enabled ? [1] : []
    content {
      subnet_id = var.subnet_id
    }
  }

  virtual_network_type = local.vnet_enabled ? var.virtual_network_type : null

  dynamic "identity" {
    for_each = var.identity_type == "None" ? [] : [1]
    content {
      type         = var.identity_type
      identity_ids = contains(["UserAssigned", "SystemAssigned, UserAssigned"], var.identity_type) ? var.user_assigned_identity_ids : null
    }
  }

  tags = local.effective_tags

  lifecycle {
    precondition {
      condition     = !(var.enable_vnet_integration && (var.subnet_id == null || var.subnet_id == ""))
      error_message = "Si enable_vnet_integration=true, debes entregar subnet_id."
    }
    precondition {
      condition     = !(var.diagnostic_settings_enabled && (var.log_analytics_workspace_id == null || var.log_analytics_workspace_id == ""))
      error_message = "Si diagnostic_settings_enabled=true, debes entregar log_analytics_workspace_id."
    }
  }
}

#########################
# Diagnostic settings (opcional)
#########################
resource "azurerm_monitor_diagnostic_setting" "apim_diag" {
  count = var.diagnostic_settings_enabled ? 1 : 0

  name                       = var.diagnostic_settings_name
  target_resource_id         = azurerm_api_management.apim.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # Logs comunes de APIM (pueden variar según API/versión; dejamos los más usados)
  enabled_log { category = "GatewayLogs" }
  enabled_log { category = "WebSocketConnectionLogs" }

  metric {
    category = "AllMetrics"
  }
}
