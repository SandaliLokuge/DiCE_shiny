## run_dice_backend.R

run_dice_pipeline <- function(dge, expr, params) {
  # dge   : data.frame with DEA results (logFC, p-values, etc.)
  # expr  : expression matrix / data.frame
  # params: list of all user-selected settings from the UI
  
  # ---- TODO: Replace everything below with your real DiCE pipeline ----
  # For now, just return a list so the app has something to hold.
  list(
    dge_head   = head(dge),
    expr_dim   = dim(expr),
    params     = params,
    timestamp  = Sys.time()
  )
}
