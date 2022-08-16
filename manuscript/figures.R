library(multibridge)
library(ggplot2)
library(RColorBrewer)

visualize_density <- function(dat, options, d_list, p_list = NULL, nsamp=200){
  
  p <- ggplot(dat[[d_list]][[d_list]], aes(x=x, y=y)) +
    stat_density_2d(aes(fill = ..level..), geom = "polygon") +
    scale_fill_distiller(palette= options[[d_list]]$palette, direction=1) 
    
  if(d_list == 'target'){
    
    p <- p + 
      geom_abline(aes(intercept=0, slope = 1),linetype=2)
    
  }
    
  if(!is.null(p_list)){
    
    p <- p + 
      geom_point(data=dat[[d_list]][[p_list]][1:nsamp,], 
                 fill = options[[p_list]]$fill_color, 
                 colour = 'black', shape=21, size=3) 
  }
  

    
  p <- p +
    theme_classic() +
    scale_x_continuous(name = options[[d_list]]$xlab, limits= options[[d_list]]$xrange) +
    scale_y_continuous(name = options[[d_list]]$ylab, limits= options[[d_list]]$yrange) +
    geom_segment(aes(y=-Inf,yend=-Inf,x=options[[d_list]]$xrange[1],xend=options[[d_list]]$xrange[2])) +
    geom_segment(aes(y=options[[d_list]]$yrange[1],yend=options[[d_list]]$yrange[2],x=-Inf,xend=-Inf)) +
    theme(axis.line=element_blank()) +
    theme(plot.margin = unit(c(0,0,1,1), "lines"), 
          legend.position='none',
          axis.text.x=element_text(size=14),  
          axis.text.y=element_text(size=14), 
          axis.title.x=element_text(size=14, vjust=-1.6), 
          axis.title.y=element_text(size=14, vjust=2.6)) 
  
  return(p)
}

# look up info about color palettes
display.brewer.pal(5, 'Oranges')
brewer.pal(5, 'Oranges') 
target_color <- #FDBE85
  
display.brewer.pal(5, 'Greens')
brewer.pal(5, 'Greens') # 
proposal_color <- #BAE4B3

# theta1 < theta2
Hr <- c('theta1 > theta2')
a  <- c(1, 1)
b  <- c(1, 1)
x  <- c(4, 7)
n  <- c(10, 10)
factor_levels <- c('theta1', 'theta2')
N <- 1e4
output  <- binom_bf_informed(x, n, Hr, a, b, niter=2*N, factor_levels, seed=2020)
boundaries    <- output$restrictions$inequality_constraints$boundaries[[1]]
binom_equal   <- output$restrictions$inequality_constraints$nr_mult_equal[[1]]
direction     <- output$restrictions$inequality_constraints$direction


target       <- samples(output)$post_samples[[1]][1:N, ]
target_4_fit <- tbinom_trans(samples(output)$post_samples[[1]][(N+1):(2*N), ], 
                             boundaries    = boundaries, 
                             binom_equal   = binom_equal,
                             hyp_direction = 'direction')
target_trans <- tbinom_trans(target, 
                             boundaries    = boundaries, 
                             binom_equal   = binom_equal,
                             hyp_direction = 'direction')


m  <- apply(target_4_fit, 2, mean) # mean vector
V  <- cov(target_4_fit)            # covariance matrix
# 6. Draw N2 samples from the proposal distribution
proposal <- mvtnorm::rmvnorm(N, m, V)
proposal_trans <- tbinom_backtrans(proposal, 
                               boundaries    = boundaries, 
                               binom_equal   = binom_equal,
                               hyp_direction = 'direction')$theta_mat

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
    xlab = 'Theta1',
    ylab = 'Theta2',
    fill_color = '#FDBE85',
    palette = 'Oranges'
    ),
  proposal = list(
    xrange=c(-3, 2), 
    yrange=c(-3, 2),
    xlab = 'Trans1',
    ylab = 'Trans2',
    fill_color = '#BAE4B3',
    palette = 'Greens'
  )
)

# Plot stuff
visualize_density(dat, options, d_list = 'target', p_list = NULL)
visualize_density(dat, options, d_list = 'target', p_list = 'target')
visualize_density(dat, options, d_list = 'target', p_list = 'proposal')

visualize_density(dat, options, d_list = 'proposal', p_list = NULL)
visualize_density(dat, options, d_list = 'proposal', p_list = 'proposal')
visualize_density(dat, options, d_list = 'proposal', p_list = 'target')

## plot: at least 100,000
library(MCMCpack)

dat <- rdirichlet(3e4, c(1, 1, 1, 1))
sortedrows <- !apply(dat,1,is.unsorted)
dat <- dat[sortedrows,]
hist(dat[,1])

dat2 <- rdirichlet(3e4, c(3, 5, 7, 10))
sortedrows <- !apply(dat2,1,is.unsorted)
dat2 <- dat2[sortedrows,]
hist(dat2[,1])

dat3 <- rdirichlet(3e4, c(5, 5, 5, 5))
sortedrows <- !apply(dat3,1,is.unsorted)
dat3 <- dat3[sortedrows,]
hist(dat3[,1])





