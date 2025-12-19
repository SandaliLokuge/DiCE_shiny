about_tab <- function() {
  tabPanel(
    title = "About",
    value = "about",
    div(
      class = "page-container",
      
      h2("About DiCE"),
      p(
        "DiCE (Differential Centrality-Ensemble analysis) is a multi-phase, network-guided gene discovery framework designed to identify 
        influential disease-associated genes that may not exhibit large fold-changes in traditional differential expression analysis. 
        By integrating Information Gain (IG), condition-specific weighted PPI networks, and multiple network centrality measures, 
        DiCE highlights genes whose functional influence shifts between biological states. This approach has been validated in 
        cancer datasets and successfully identifies survival-linked and cancer-fitness genes overlooked by classical differential gene expression (DGE) methods."
      ),
      
      br(),
      
      div(
        class = "phase-summary",
        
        tags$h4("Publication"),
        
        tags$p(
          tags$b("DiCE: differential centrality-ensemble analysis based on gene expression profiles and protein-protein interaction network")
        ),
        
        tags$p(
          "Pashaei, E., Liu, S., Li, K.Y., Zang, Y., Yang, L., Lautenschlaeger, T., Huang, J., Lu, X., & Wan, J. (2025). DiCE: differential centrality-ensemble analysis based on gene expression profiles and protein–protein interaction network. Nucleic Acids Research, 53."
        ),
        
        tags$p(
          tags$a(
            "View article (Nucleic Acids Research)",
            href   = "https://academic.oup.com/nar/article/53/13/gkaf609/8192812",
            target = "_blank"
          )
        )
      ),
      
      br(),
      
      div(
        id = "docs_section",
        
        h2("Documentation"),
        
        h3("Overview"),
        p(
          "DiCE-Ex implements the complete DiCE workflow, allowing users to upload bulk RNA-seq datasets and 
          run all phases—from DGE-based candidate gene selection to IG filtering, network reconstruction, centrality analysis, 
          and ensemble ranking. The platform supports human and mouse datasets and provides interactive visualization of 
          DiCE genes, PPI subnetworks, and community modules."
        ),
        p(
          "DiCE-Ex provides clear advantages over standalone R packages by offering an integrated, end-to-end, and user-configurable workflow."
        ),
        
        br(),
        
        h3("Input Requirements"),
        p("DiCE-Ex supports multiple file formats including .csv, .tsv, .xlsx, and .rds."),
        
        h4("Bulk RNA-seq Inputs"),
        
        tags$ul(
          tags$li(
            tags$p(
              "Normalized expression matrix (logCPM), formatted as samples × genes with one additional class/Group/Condition column. ",
              "Do not place sample names as the first column."
            ),
            tags$img(
              src = "images/gene_expr_image.png",
              style = "max-width:600px; margin-top:6px; border:1px solid #ddd; border-radius:6px;"
            )
          ),
          tags$li(
            tags$p("Differential expression analysis (DEA) results with columns: Gene.Symbol, P.Value, adj.P.Val, logFC."),
            tags$img(
              src = "images/dge_image.png",
              style = "max-width:300px; margin-top:6px; border:1px solid #ddd; border-radius:6px;"
            )
          )
        ),
        
        br(),
        
        h3("Workflow Summary"),
        p("DiCE consists of five main phases that progressively refine and prioritize biologically meaningful genes:"),
        
        h4("Phase I — Candidate Gene Pool"),
        tags$ul(
          tags$li("DGE is applied using loose cutoffs (e.g., adj.P.Val < 0.05) to capture genes with subtle but relevant expression shifts.")
        ),
        
        h4("Phase II — Information Gain (IG) Filtering"),
        tags$ul(
          tags$li("IG quantifies entropy reduction: how well a gene separates the two conditions."),
          tags$li("Weighted IG option (WIG) available for imbalanced datasets using Monte Carlo resampling."),
          tags$li("Supported IG cutoffs: all_mean, all_median, nonzero_mean, nonzero_median, all_nonzero.")
        ),
        
        h4("Phase III — Condition-specific Weighted PPI Networks"),
        tags$ul(
          tags$li("Uses STRING (Version 12.0) database."),
          tags$li("Genes not present in STRING or without interactions are excluded."),
          tags$li("Weights derived from 1 − |correlation| to capture phenotype-specific network rewiring.")
        ),
        
        h4("Phase IV — Network Centrality Analysis"),
        tags$ul(
          tags$li(
            "Computes multiple centrality measures selected from betweenness, eigenvector, closeness, PageRank, harmonic, strength, and authority.",
            
            tags$div(
              style = "margin-top:10px; margin-left:15px;",
              
              tags$p(
                tags$b("Note: "),
                "Avoid selecting highly correlated centrality measures together, as they capture similar topological information."
              ),
              
              tags$p(
                "For example, Eigenvector centrality and Authority often exhibit strong correlations, 
                indicating redundant topological information."
              ),
              
              fluidRow(
                column(
                  width = 6,
                  tags$img(
                    src   = "images/tcga_prad_heatmap.png",
                    style = "width:100%; border:1px solid #ddd; border-radius:6px;",
                    alt   = "Centrality correlations in Cancer Genome Atlas Prostate Adenocarcinoma (TCGA-PRAD)"
                  ),
                  tags$p(
                    style = "text-align:center; font-size:0.9em; margin-top:5px;",
                    "TCGA-PRAD dataset"
                  )
                ),
                column(
                  width = 6,
                  tags$img(
                    src   = "images/nepc_heatmap.png",
                    style = "width:100%; border:1px solid #ddd; border-radius:6px;",
                    alt   = "Centrality correlations in a Neuroendocrine Prostate Cancer (NEPC) dataset"
                  ),
                  tags$p(
                    style = "text-align:center; font-size:0.9em; margin-top:5px;",
                    "NEPC 2019 dataset"
                  )
                )
              )
            )
          ),
          
          tags$li(
            "Genes that exceed user-defined thresholds (mean, median, or top-K%) in at least one condition for all selected centralities are designated as ",
            tags$b("DiCE genes.")
          )
        ),
        
        h4("Phase V — Ensemble Ranking"),
        tags$ul(
          tags$li("All genes are ranked based on the absolute differences in each selected centrality measure between the two conditions."),
          tags$li("A consensus ensemble rank is then computed using the ProductOfRank method.")
        ),
        
        br(),
        
        h3("Outputs and Result Interpretation"),
        
        tags$p(
          "DiCE-Ex outputs are designed to support both gene-level prioritization and network-level interpretation. 
          Below we describe how users should interpret each type of result returned by the platform."
        ),
        
        tags$ul(
          tags$li(
            tags$b("DiCE-Ex Results Table: "),
            "Contains all genes retained across DiCE phases, along with differential expression metrics, 
            IG or Weighted IG scores, network centrality values for each condition, and final ensemble ranks. 
            Genes ranked at the top represent candidates with both expression relevance and high network influence."
          ),
          tags$li(
            tags$b("Final DiCE Gene Set: "),
            "Represents genes with consistent and meaningful shifts in network centrality between conditions. 
            These genes are prioritized as condition-associated critical genes."
          ),
          tags$li(
            tags$b("Community Modules: "),
            "Detected modules in the STRING-derived interaction network of DiCE genes represent groups of tightly connected genes that may correspond to shared biological processes or pathways. ",
            "Users can filter by gene name or module number to view module-specific subnetworks. ",
            "Selecting a gene in the results table highlights its subnetwork within the module, ",
            "and selecting a node in the network shows boxplots of expression across conditions."
          ),
          tags$li(
            tags$b("Exported Files: "),
            "DiCE and module results can be downloaded for downstream analyses such as pathway enrichment 
            or Cytoscape-based visualization."
          )
        ),
        
        br()
      ), # end docs_section
      
      div(
        id = "updates_section",
        h2("DiCE Version History"),
        
        h3("V1.1.3 — Latest Release"),
        tags$ul(
          tags$li("Added IG cutoff methods: all_mean, all_median, nonzero_mean, nonzero_median, all_nonzero."),
          tags$li("Added automatic filtering to retain only protein-coding genes (GENCODE v22)."),
          tags$li("Expanded network centralities: authority, strength, closeness, pagerank, harmonic."),
          tags$li("Added Louvain-based module detection for DiCE PPI subnetworks.")
        ),
        
        h3("V1.1.2"),
        tags$ul(
          tags$li("Stability fixes for eigenvector centrality when genes have zero variance.")
        ),
        
        h3("V1.1.1"),
        tags$ul(
          tags$li("Added IG information for Phase 1 genes."),
          tags$li("Unified output: one dataframe containing all Phase 1–3 genes and final DiCE genes."),
          tags$li("Better handling of user-provided column name variations.")
        ),
        
        h3("V1.1.0"),
        tags$ul(
          tags$li("Introduced final ensemble ranking for all genes."),
          tags$li("Replaced STRINGdb R package with downloaded interaction files of STRING Version 12.0 for consistent mapping."),
          tags$li("Corrected eigenvector centrality computation using correlation-derived edge weights.")
        )
      ) # end updates_section
    ) # end page-container
  )
}
