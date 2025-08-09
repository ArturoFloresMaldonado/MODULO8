# -------------------------------------------------------
# Script: depuracion_ess_media.R
# Descripción: Importación y depuración de la base 
#              "ESS Theme - Media use and trust"
# Autor: Arturo Flores Maldonado
# -------------------------------------------------------

paquetes <- c("dplyr", "readr")

paquetes_instalar <- paquetes[!(paquetes %in% installed.packages()[, "Package"])]
if (length(paquetes_instalar) > 0) {
  install.packages(paquetes_instalar)
}

lapply(paquetes, library, character.only = TRUE)

datos_raw <- read_csv("Datos/Base de datos original/ESS Theme - Media use and trust.csv")

# Revisión inicial --------------------------------------
glimpse(datos_raw)

# recodificar valores especiales a NA -------
recode_na <- function(x) {
  na_values <- c(66, 77, 88, 99, 6666, 7777, 8888, 9999)
  x <- ifelse(x %in% na_values, NA, x)
  return(x)
}

# aplicar recodificación a todas las columnas numéricas --
datos_clean <- datos_raw %>%
  mutate(across(where(is.numeric), recode_na))

#Seleccionar variables clave ---------------------------
datos_clean <- datos_clean %>%
  select(
    essround, cntry, idno,
    netuse, netusoft, netustm,
    nwspol, nwsppol, nwsptot,
    rdpol, rdtot, tvpol, tvtot,
    pplfair, pplhlp, ppltrst
  )

# Renombrar variables ------------------------------------
datos_clean <- datos_clean %>%
  rename(
    ronda = essround,
    pais = cntry,
    id = idno,
    uso_internet_frecuencia = netuse,
    uso_internet_actividades = netusoft,
    uso_internet_tiempo_min = netustm,
    noticias_politicas_min = nwspol,
    noticias_politicas_prensa = nwsppol,
    noticias_totales_prensa = nwsptot,
    lectura_politica = rdpol,
    lectura_total = rdtot,
    tv_politica = tvpol,
    tv_total = tvtot,
    justicia_personas = pplfair,
    ayuda_personas = pplhlp,
    confianza_personas = ppltrst
  )

# Guardar datos depurados -------------------------------
write_csv(datos_clean, "Datos/Base de datos depurada/ESS_media_dep.csv")
