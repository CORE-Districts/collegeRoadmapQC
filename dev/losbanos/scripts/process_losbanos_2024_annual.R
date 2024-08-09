district <- "losbanos"
period <- "annual"
year <- 2024
create_xwalk(district,period,feather_file_type = "xwalk")
source_loading_instructions(district,period)
feather_file_loading_shell(district,period,loading_instructions = losbanos_loading_instructions)
create_name_crosswalks(district,period)
apply_all_name_crosswalks(district,period)
render_qc_report(district,period,template = staticValues$qc_template$qc_report)
