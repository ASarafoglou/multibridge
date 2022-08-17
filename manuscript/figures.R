library(multibridge)
library(ggplot2)
library(RColorBrewer)
library(rcartocolor)

visualize_density <- function(dat, options, d_list, p_list = NULL, text=NULL, samp=1:100, density=TRUE){
  
  p <- ggplot(dat[[d_list]][[d_list]], aes(x=x, y=y))
  
  if(density){
    
    p <- p +
      stat_density_2d(aes(fill = ..level..), geom = "polygon") +
      scale_fill_gradient(low  = options[[d_list]]$palette_low, 
                          high = options[[d_list]]$palette_high) 
    
  }
  
  if(d_list == 'target'){
    
    p <- p + 
      geom_abline(aes(intercept=0, slope = 1),linetype=2)
    
  }
    
    if(!is.null(p_list)){
      
      p <- p + 
        geom_point(data=dat[[d_list]][[p_list]][samp,], 
                   fill = options[[p_list]]$fill_color, 
                   colour = 'black', shape=21, size=4) 
    }

    
    if(!is.null(text)){
      
      p <- p +
        annotate("text", x=0.8, y=-2.1, label= text[[1]], size=10) + 
        annotate("text", x=-1.5, y=1.5, label= text[[2]], size=10)
      
    }

  p <- p +
    theme_classic() +
    scale_x_continuous(name = options[[d_list]]$xlab, limits= options[[d_list]]$xrange) +
    scale_y_continuous(name = options[[d_list]]$ylab, limits= options[[d_list]]$yrange) +
    geom_segment(aes(y=-Inf,yend=-Inf,x=options[[d_list]]$xrange[1],xend=options[[d_list]]$xrange[2])) +
    geom_segment(aes(y=options[[d_list]]$yrange[1],yend=options[[d_list]]$yrange[2],x=-Inf,xend=-Inf)) +
    theme(axis.line=element_blank()) +
    theme(plot.margin = unit(c(1,1,0.5,0.5), "lines"), 
          legend.position='none',
          axis.text.x=element_text(size=28),  
          axis.text.y=element_text(size=28), 
          axis.title.x=element_text(size=14, vjust=-1.6), 
          axis.title.y=element_text(size=14, vjust=2.6)) 
  
  return(p)
}

# look up info about color palettes
display_carto_all()

palette_target <- 'OrYel'
display_carto_pal(7, palette_target)
carto_pal(7, palette_target)
target_color <- '#FB9A99'
target_low   <- '#FEEEEE'
target_high  <- '#BD7473'

palette_proposal <- 'TealGrn'
display_carto_pal(7, palette_proposal)
carto_pal(7, palette_proposal) # 
proposal_color <- '#63A3CC'
proposal_low <- '#D3E7F1'
proposal_high <- '#1F78B4'

# theta1 < theta2
Hr <- c('theta1 < theta2')
a  <- c(1, 1)
b  <- c(1, 1)
x  <- c(4, 7)
n  <- c(10, 10)
factor_levels <- c('theta1', 'theta2')
N <- 3e4
output  <- binom_bf_informed(x, n, Hr, a, b, niter=2*N, factor_levels, seed=2020)
boundaries    <- output$restrictions$inequality_constraints$boundaries[[1]]
binom_equal   <- output$restrictions$inequality_constraints$nr_mult_equal[[1]]
direction     <- output$restrictions$inequality_constraints$direction


target       <- samples(output)$post_samples[[1]][1:N, ]
target_4_fit <- tbinom_trans(samples(output)$post_samples[[1]][(N+1):(2*N), ], 
                             boundaries    = boundaries, 
                             binom_equal   = binom_equal,
                             hyp_direction = direction)
target_trans <- tbinom_trans(target, 
                             boundaries    = boundaries, 
                             binom_equal   = binom_equal,
                             hyp_direction = direction)


m  <- apply(target_4_fit, 2, mean) # mean vector
V  <- cov(target_4_fit)            # covariance matrix
# 6. Draw N2 samples from the proposal distribution
proposal <- mvtnorm::rmvnorm(N, m, V)
proposal_trans <- tbinom_backtrans(proposal, 
                               boundaries    = boundaries, 
                               binom_equal   = binom_equal,
                               hyp_direction = direction)$theta_mat

dat <- list(
  target = list(
    target=target, 
    proposal=proposal_trans
  ), 
  proposal = list(
    proposal=proposal,
    target=target_trans
  )
)
dat <- lapply(dat, function(i) lapply(i, function(j) data.frame(x = j[,1], 
                                                                y = j[,2])))

options <- list(
  target = list(
    xrange=c(0,1), 
    yrange=c(0,1),
    xlab = "",
    ylab = "",
    # xlab = expression(theta[1]),
    # ylab = expression(theta[2]),
    fill_color = target_color,
    palette = palette_target,
    palette_low = target_low,
    palette_high = target_high
    ),
  proposal = list(
    xrange=c(-2.5, 2.5), 
    yrange=c(-2.5, 2.5),
    xlab = "",
    ylab = "",
    # xlab = expression(xi[1]),
    # ylab = expression(xi[2]),
    fill_color = proposal_color,
    palette = palette_proposal,
    palette_low = proposal_low,
    palette_high = proposal_high
  )
)

text <- list(
  expression(Sigma ~ '=' ~ bgroup("(", atop(" 0.12  -0.08", "-0.08   0.42"), ")")),
  expression(mu ~ '=' ~ bgroup("(", atop("-0.28", "-0.14"), ")"))
)
  

# Plot stuff
visualize_density(dat, options, d_list = 'target', p_list = NULL)
visualize_density(dat, options, d_list = 'target', p_list = 'target', samp=1:50)
visualize_density(dat, options, d_list = 'target', p_list = 'target', samp=50:100)
visualize_density(dat, options, d_list = 'proposal', p_list = 'target', density=FALSE, samp=1:50, text=text)
visualize_density(dat, options, d_list = 'proposal', p_list = 'target', density=FALSE, samp=50:100)


visualize_density(dat, options, d_list = 'target', p_list = 'target', samp=1:200)
visualize_density(dat, options, d_list = 'target', p_list = 'proposal', samp=1:50)

visualize_density(dat, options, d_list = 'proposal', p_list = NULL)
visualize_density(dat, options, d_list = 'proposal', text=text)
visualize_density(dat, options, d_list = 'proposal', p_list = 'proposal', samp=1:50)
visualize_density(dat, options, d_list = 'proposal', p_list = 'target', samp=50:100)
visualize_density(dat, options, d_list = 'target', p_list = 'proposal', density=FALSE, samp=1:50)

# ## plot: at least 100,000
# library(MCMCpack)
# 
# dat <- rdirichlet(3e4, c(1, 1, 1, 1))
# sortedrows <- !apply(dat,1,is.unsorted)
# dat <- dat[sortedrows,]
# hist(dat[,1])
# 
# dat2 <- rdirichlet(3e4, c(3, 5, 7, 10))
# sortedrows <- !apply(dat2,1,is.unsorted)
# dat2 <- dat2[sortedrows,]
# hist(dat2[,1])
# 
# dat3 <- rdirichlet(3e4, c(5, 5, 5, 5))
# sortedrows <- !apply(dat3,1,is.unsorted)
# dat3 <- dat3[sortedrows,]
# hist(dat3[,1])





