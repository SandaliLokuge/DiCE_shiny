# ui_results.R

results_tab <- function() {
  tabPanel(
    "Results",
    value = "results",
    
    div(
      class = "page-container",
      
      br(),
      h3("DiCE Results"),
      
      uiOutput("job_status_ui"),
      uiOutput("error_help_ui"),
      uiOutput("job_progress_ui"),
      
      uiOutput("dice_job_title"),
      uiOutput("phase_summary"),
      br(),
      
      tabsetPanel(
        id   = "results_inner_tabs",
        type = "tabs",
        
        ## -------------------------------------------------
        ## 1. DiCE Results TAB
        ## -------------------------------------------------
        tabPanel(
          title = "DiCE Results",
          br(),
          
          # Top bar: download button (left) + phase + gene search (right)
          fluidRow(
            column(
              width = 6,
              uiOutput("download_buttons_ui")
            ),
            column(
              width = 6,
              div(
                style = "display:flex; justify-content:flex-end; align-items:center; gap:20px;",
                
                # Phase dropdown (drives input$dice_phase_filter)
                div(
                  style = "display:flex; align-items:center;",
                  tags$label("Phase:", style = "margin-right:8px; font-weight:600;"),
                  selectInput(
                    inputId  = "dice_phase_filter",
                    label    = NULL,
                    choices  = c("All phases" = "all"),
                    selected = "all",
                    width    = "150px"
                  )
                ),
                
                # Gene search box (drives input$dice_search)
                div(
                  style = "display:flex; align-items:center;",
                  tags$label("Gene:", style = "margin-right:8px; font-weight:600;"),
                  textInput(
                    inputId     = "dice_search",
                    label       = NULL,
                    placeholder = "e.g., CDK1",
                    width       = "180px"
                  )
                )
              )
            )
          ),
          
          br(),
          DT::DTOutput("dice_table")
        ),
        
        ## -------------------------------------------------
        ## 2. DiCE PPI modules TAB
        ## -------------------------------------------------
        tabPanel(
          "DiCE PPI modules",
          
          h3("Module summary"),
          div(
            style = "margin-bottom:10px;",
            uiOutput("download_modules_ui")
          ),
          DTOutput("modules_summary_table"),
          br(),
          
          h3("Module membership & module subnetwork"),
          helpText(
            "Use the module selector or the search box to filter rows. ",
            "Click a gene row to visualize its subnetwork (within its module) on the right."
          ),
          helpText(
            "By clicking a node in the network, you can view the gene expression changes."
          ),
          
          fluidRow(
            # left: membership table + filters
            column(
              width = 6,
              
              # Module filter
              selectInput(
                "mm_module_filter",
                "Filter by module",
                choices  = c("All modules" = "all"),  # updated from server
                selected = "all",
                width = "50%"  
              ),
              
              # Gene search
              div(
                style = "margin:8px 0 10px 0;",
                textInput(
                  inputId     = "mm_gene_search",   # <-- matches server
                  label       = "Gene search:",
                  placeholder = "e.g., POLE2",
                  width       = "50%"
                )
              ),
              
              DTOutput("modules_membership_table")
            ),
            
            # right: visNetwork subnetwork
            column(
              width = 6,
              style = "padding-right:0;",
              
              div(
                class = "module-network-panel",
                style = "margin-top:40px;",
                visNetworkOutput(
                  "ppi_module_network",
                  height = "650px",
                  width  = "100%"
                )
              )
            )
          )
        )
      )
    )
  )
}
