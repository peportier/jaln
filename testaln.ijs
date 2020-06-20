load '~Shared/aln/aln.ijs'
require'trig'
require'plot'
require'numeric'

funk=: 3 : '(^y) * cos 2*pi * sin pi * y'
noise=: 4 : 'y + -&x *&(+:x) ? (#y) # 0'

gendat=: 4 : 0
  X =: ? y $ 0
  Y__aln =: x noise funk X
  0
)

inittransform=: ] ,. ^&2 ,. ^&3

init =: 3 : 0
  0.5 gendat 100
  D__aln=: inittransform X
  W__aln=: 6
  F__aln=: fmul
  ridgeCoef__aln=: 1E_4
  residualLinks__aln=: 0
  ntrain=. <. 0.8 * #X
  neval=. (#X) - ntrain
  M__aln=: ((# ? #) X) { (ntrain,neval) # 1 0
)

go=: 3 : 0
  aln =: '' conew 'pepaln'
  init ''
  predict=: [: comp__aln (learn__aln'')"_
  plotres ''
)

plotdatnoshow=: 3 : 0
  pd 'reset'
  pd 'color green'
  pd 'type marker'
  pd 'markersize 1'
  pd 'markers circle'
  pd (M__aln # X);(M__aln # Y__aln)
  pd 'color yellow'
  pd ((-.M__aln) # X);((-.M__aln) # Y__aln)

  pd 'color red'
  pd 'type line'
  pd 'pensize 1'
  pd (;funk) steps 0 1 100

)
plotdat=: 3 : 0
  plotdatnoshow 0
  pd 'show'
)

plotres=: 3 : 0
  plotdatnoshow 0
  pd 'color blue'
  xs=: steps 0 1 100
  D__aln=: inittransform xs
  pd xs; predict ''
  pd 'show'
)