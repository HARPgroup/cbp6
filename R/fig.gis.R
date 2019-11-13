fig.gis <- function(riv.seg, site_number, site_url, cbp6_link, token) {
  # Generating gage location maps
  gis_img <- fn_gage_and_seg_mapperALT(riv.seg, site_number, site_url, cbp6_link, token)
  ggsave("gis.png", plot = gis_img, device = 'png', width = 8, height = 5.5, units = 'in')
}