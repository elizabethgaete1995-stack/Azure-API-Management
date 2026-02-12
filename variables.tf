############################
# Tags estándar (obligatorio)
############################
variable "entity" {
  description = "Nombre del cliente."
  type        = string
}

variable "environment" {
  description = "Ambiente: dev, pre, pro."
  type        = string
  validation {
    condition     = contains(["dev", "pre", "pro"], lower(var.environment))
    error_message = "environment debe ser: dev, pre o pro."
  }
}

variable "app_name" {
  description = "Nombre de la aplicación."
  type        = string
}

variable "cost_center" {
  description = "Identificador del centro de costo."
  type        = string
}

variable "tracking_code" {
  description = "Nombre/código del proyecto."
  type        = string
}

variable "custom_tags" {
  description = "Tags adicionales."
  type        = map(string)
  default     = {}
}

variable "inherit" {
  description = "Si true, hereda tags desde el Resource Group."
  type        = bool
  default     = true
}

############################################
# Resource Group / Location / Subscription
############################################
variable "rsg_name" {
  description = "Nombre del Resource Group donde se despliega."
  type        = string
}

variable "location" {
  description = "Azure region donde se despliega (ej: eastus2, brazilsouth)."
  type        = string
}

variable "subscriptionid" {
  description = "Subscription ID destino."
  type        = string
}

variable "tenantid" {
  description = "Tenant ID destino."
  type        = string
}

variable "inherit" {
  description = "Si true, hereda tags del Resource Group y los mezcla con standard + custom."
  type        = bool
  default     = true
}
############################
# Básicos APIM (obligatorios)
############################
variable "rsg_name" {
  description = "Resource Group donde se despliega APIM."
  type        = string
}

variable "location" {
  description = "Región Azure."
  type        = string
}

variable "apim_name" {
  description = "Nombre del APIM (debe ser único)."
  type        = string
}

variable "publisher_name" {
  description = "Publisher name requerido por APIM."
  type        = string
}

variable "publisher_email" {
  description = "Publisher email requerido por APIM."
  type        = string
}

variable "sku_name" {
  description = "SKU de APIM, ej: Developer_1, Premium_1, Standard_1, Basic_1."
  type        = string
  default     = "Developer_1"
}

variable "capacity" {
  description = "Capacidad/unidades (según SKU). En muchos SKU va embebido en sku_name, pero se expone para control."
  type        = number
  default     = 1
}

############################
# Identidad (opcional)
############################
variable "identity_type" {
  description = "Identity type: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
  type        = string
  default     = "SystemAssigned"
  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned", "None"], var.identity_type)
    error_message = "identity_type debe ser: None, SystemAssigned, UserAssigned o 'SystemAssigned, UserAssigned'."
  }
}

variable "user_assigned_identity_ids" {
  description = "Lista de IDs de UAI si usas UserAssigned."
  type        = list(string)
  default     = []
}

############################
# Red/VNet (opcional)
############################
variable "enable_vnet_integration" {
  description = "Habilita integración con VNet."
  type        = bool
  default     = false
}

variable "virtual_network_type" {
  description = "Internal o External cuando VNet está habilitado."
  type        = string
  default     = "External"
  validation {
    condition     = contains(["Internal", "External"], var.virtual_network_type)
    error_message = "virtual_network_type debe ser Internal o External."
  }
}

variable "subnet_id" {
  description = "Subnet ID para APIM (requerido si enable_vnet_integration=true)."
  type        = string
  default     = null
}

############################
# Diagnósticos a Log Analytics (opcional)
############################
variable "diagnostic_settings_enabled" {
  description = "Habilita Diagnostic Settings hacia Log Analytics."
  type        = bool
  default     = false
}

variable "diagnostic_settings_name" {
  description = "Nombre de la configuración de diagnóstico."
  type        = string
  default     = "apim-diagnostics"
}

variable "log_analytics_workspace_id" {
  description = "ID del Log Analytics Workspace."
  type        = string
  default     = null
}
