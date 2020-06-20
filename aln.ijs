coclass 'pepaln'

NB. Fields:
NB. Y: target values
NB. D: explanatory variables
NB. M: binary vector, train/test mask
NB. W: layer width i.e. nb of nodes per layer
NB. F: transformation applied at each node (e.g. flin or fmul)
NB. ridgeCoef: l2 regularization
NB. residualLinks: boolean

create=: 3 : '0'

destroy=: codestroy

mp=: 4 : 'try. x (+/ . *) y catch. _ end.'
flin=: 1: ,. ]
fmul=: 1: ,. ] ,. */"1
am=: +/ % # NB. arithmetic mean
rms=: am &.: *: NB. root mean square
rmse=: rms @: - NB. root mean squared error
div=: 4 : 'try. x %. y catch. ({:$y)$_ end.'
diag=: (<0 1)&|: : (([:(>:*i.)[:#])})
addDiag=: ([+diag@]) diag ] NB. add x to the diagonal of y
pairs0=: ;@(>: (<@}.)"(0 2) (,"0)/~)@i.
pairs1=: 4 : '|: (y#i.x) ,: ;x#<x+i.y'
pairs=: 4 : '(x pairs1 y) , x + pairs0 y'

init=: 3 : 0
I=: D NB. new layer input
dim=: {:$D
N=: $,F ,: 1 1 NB. size of a node output
NET=: (0,W,3+N)$0
)

node=: 3 : 0
('i';'j')=. y
v=: F (i,j) {"1 I
a=. M#v
s=. (mp~ |:) a
c=: ((|:a) mp M#Y)div(ridgeCoef addDiag s)
L=: L,i,j,c, ((-.M)#Y) rmse c mp |:(-.M)#v
)

layer=: 3 : 0
L=: (0,3+N)$0                           NB. init new layer L
if. 0=#NET do. p=. pairs0 dim           NB. potential nodes for all I cols pairs
else. if. residualLinks do. 
p=. dim pairs W 
else. p=. dim + pairs0 W end. end.
node"1 p
NET=: NET,L=: (W{./:{:"1 L){L           NB. keep W best nodes
v=. _2 (F@|:)\ |: (, (i.2) {"1 L) {"1 I NB. F-transformed pairs of I cols
c=. (2+i.N) {"1 L                       NB. regression coefficients
I=: D ,"1 |: v mp"2 1 c                 NB. output of L prefixed with initial data is next layer input
)

minscore=: 3 : '<./ {:"1 {: y'

learn=: 3 : 0
init ''
curminscore=: minscore NET [ prevminscore=: _ [ layer ''
while. (prevminscore - curminscore) > 1E_3 do.
   curminscore=: minscore NET [ prevminscore=: curminscore [ layer ''
end.
(<:#NET) , (i.<./) {:"1 {: NET=: }: NET NB. output node coordinates
)

rownum=: 3 : 'if. 0 <: y - dim do. y-dim else. y end.'
row=: 3 : '(< (0{y) ; rownum 1{y) { NET'
coef=: 3 : '(2+i.N) { y'
base=: 3 : 'F (1 2 { y) {"1 D'
ix=: 3 : '((((<:{.y)"_`0:) @. (] < dim"_)) , ])"(0) 1 2 { y'
rec=: 3 : 'F |: comp"1 ix y'
dat=: rec`base @. ({. = 0:)
comp=: dat@({.,row) mp coef@row