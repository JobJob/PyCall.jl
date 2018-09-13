Baseline

Mean times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(11.937 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.851 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.431 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(5.893 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.490 μs)
pycall! (1, 1, 1)                	TrialEstimate(1.222 μs)
pycall_legacy (1,)               	TrialEstimate(4.555 μs)
pycall (1,)                      	TrialEstimate(1.248 μs)
pycall! (1,)                     	TrialEstimate(1.087 μs)
pycall_legacy ()                 	TrialEstimate(535.918 ns)
pycall ()                        	TrialEstimate(565.792 ns)
pycall! ()                       	TrialEstimate(441.703 ns)

Median times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(10.589 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.747 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.271 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(5.207 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.275 μs)
pycall! (1, 1, 1)                	TrialEstimate(1.079 μs)
pycall_legacy (1,)               	TrialEstimate(3.949 μs)
pycall (1,)                      	TrialEstimate(1.085 μs)
pycall! (1,)                     	TrialEstimate(972.848 ns)
pycall_legacy ()                 	TrialEstimate(424.233 ns)
pycall ()                        	TrialEstimate(444.280 ns)
pycall! ()                       	TrialEstimate(392.579 ns)

--------------------------------------------------------------------------------
1) No map, i.e. just `pyarg = PyObject(args[i])` instead of `oargs = map(PyObject, args)`

Mean times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(2.003 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.664 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.505 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(1.604 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.346 μs)
pycall! (1, 1, 1)                	TrialEstimate(1.132 μs)
pycall_legacy (1,)               	TrialEstimate(2.126 μs)
pycall (1,)                      	TrialEstimate(1.347 μs)
pycall! (1,)                     	TrialEstimate(1.124 μs)
pycall_legacy ()                 	TrialEstimate(585.261 ns)
pycall ()                        	TrialEstimate(590.947 ns)
pycall! ()                       	TrialEstimate(480.194 ns)

Median times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(1.814 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.478 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.335 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(1.459 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.230 μs)
pycall! (1, 1, 1)                	TrialEstimate(1.086 μs)
pycall_legacy (1,)               	TrialEstimate(1.907 μs)
pycall (1,)                      	TrialEstimate(1.189 μs)
pycall! (1,)                     	TrialEstimate(993.800 ns)
pycall_legacy ()                 	TrialEstimate(454.430 ns)
pycall ()                        	TrialEstimate(470.263 ns)
pycall! ()                       	TrialEstimate(428.379 ns)

--------------------------------------------------------------------------------
2)
a) No map, i.e. just `pyarg = PyObject(args[i])` instead of `oargs = map(PyObject, args)`
b) removal of `ret::PyObject` return value type assert

Mean times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(1.949 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.775 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.384 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(1.677 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.516 μs)
pycall! (1, 1, 1)                	TrialEstimate(1.254 μs)
pycall_legacy (1,)               	TrialEstimate(2.101 μs)
pycall (1,)                      	TrialEstimate(1.342 μs)
pycall! (1,)                     	TrialEstimate(1.160 μs)
pycall_legacy ()                 	TrialEstimate(576.925 ns)
pycall ()                        	TrialEstimate(598.014 ns)
pycall! ()                       	TrialEstimate(483.645 ns)

Median times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(1.775 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.526 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.300 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(1.466 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.321 μs)
pycall! (1, 1, 1)                	TrialEstimate(1.147 μs)
pycall_legacy (1,)               	TrialEstimate(1.809 μs)
pycall (1,)                      	TrialEstimate(1.147 μs)
pycall! (1,)                     	TrialEstimate(1.006 μs)
pycall_legacy ()                 	TrialEstimate(451.462 ns)
pycall ()                        	TrialEstimate(487.558 ns)
pycall! ()                       	TrialEstimate(451.314 ns)

--------------------------------------------------------------------------------
3)
a) no map, i.e. just `pyarg = PyObject(args[i])` instead of `oargs = map(PyObject, args)`
b) unsplat args, kwargs

Mean times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(1.940 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.780 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.454 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(1.595 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.468 μs)
pycall! (1, 1, 1)                	TrialEstimate(1.276 μs)
pycall_legacy (1,)               	TrialEstimate(1.423 μs)
pycall (1,)                      	TrialEstimate(1.353 μs)
pycall! (1,)                     	TrialEstimate(1.147 μs)
pycall_legacy ()                 	TrialEstimate(557.894 ns)
pycall ()                        	TrialEstimate(606.302 ns)
pycall! ()                       	TrialEstimate(480.258 ns)

Median times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(1.746 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.493 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.326 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(1.405 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.284 μs)
pycall! (1, 1, 1)                	TrialEstimate(1.116 μs)
pycall_legacy (1,)               	TrialEstimate(1.164 μs)
pycall (1,)                      	TrialEstimate(1.182 μs)
pycall! (1,)                     	TrialEstimate(1.039 μs)
pycall_legacy ()                 	TrialEstimate(442.243 ns)
pycall ()                        	TrialEstimate(486.409 ns)
pycall! ()                       	TrialEstimate(437.507 ns)

--------------------------------------------------------------------------------
3)
a) no map, i.e. just `pyarg = PyObject(args[i])` instead of `oargs = map(PyObject, args)`
b) unsplat args, kwargs
c) removal of `ret::PyObject` return value type assert

Mean times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(1.874 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.706 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.446 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(1.539 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.435 μs)
pycall! (1, 1, 1)                	TrialEstimate(1.207 μs)
pycall_legacy (1,)               	TrialEstimate(1.464 μs)
pycall (1,)                      	TrialEstimate(1.401 μs)
pycall! (1,)                     	TrialEstimate(1.126 μs)
pycall_legacy ()                 	TrialEstimate(563.254 ns)
pycall ()                        	TrialEstimate(589.817 ns)
pycall! ()                       	TrialEstimate(451.760 ns)

Median times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(1.640 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.464 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.318 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(1.276 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.265 μs)
pycall! (1, 1, 1)                	TrialEstimate(1.097 μs)
pycall_legacy (1,)               	TrialEstimate(1.291 μs)
pycall (1,)                      	TrialEstimate(1.206 μs)
pycall! (1,)                     	TrialEstimate(1.002 μs)
pycall_legacy ()                 	TrialEstimate(438.707 ns)
pycall ()                        	TrialEstimate(480.480 ns)
pycall! ()                       	TrialEstimate(437.325 ns)

--------------------------------------------------------------------------------
4)
a) no map, i.e. just `pyarg = PyObject(args[i])` instead of `oargs = map(PyObject, args)`
b) unsplat args, kwargs
c) removal of `ret::PyObject` return value type assert
d) pyargsptr as ptr not object

Mean times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(1.583 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.643 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.491 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(1.457 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.443 μs)
pycall! (1, 1, 1)                	TrialEstimate(1.286 μs)
pycall_legacy (1,)               	TrialEstimate(1.288 μs)
pycall (1,)                      	TrialEstimate(1.406 μs)
pycall! (1,)                     	TrialEstimate(1.143 μs)
pycall_legacy ()                 	TrialEstimate(538.747 ns)
pycall ()                        	TrialEstimate(601.586 ns)
pycall! ()                       	TrialEstimate(471.098 ns)

Median times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(1.415 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.460 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.313 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(1.231 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.251 μs)
pycall! (1, 1, 1)                	TrialEstimate(1.114 μs)
pycall_legacy (1,)               	TrialEstimate(1.142 μs)
pycall (1,)                      	TrialEstimate(1.204 μs)
pycall! (1,)                     	TrialEstimate(1.022 μs)
pycall_legacy ()                 	TrialEstimate(430.542 ns)
pycall ()                        	TrialEstimate(481.570 ns)
pycall! ()                       	TrialEstimate(438.470 ns)

--------------------------------------------------------------------------------
5)
a) no map, i.e. just `pyarg = PyObject(args[i])` instead of `oargs = map(PyObject, args)`
b) unsplat args, kwargs
c) removal of `ret::PyObject` return value type assert
d) pyargsptr as ptr not object
e) plus pycall_legacy!

Mean times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(1.712 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.801 μs)
pycall_legacy! 7*(1,1,...)       	TrialEstimate(1.304 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.422 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(1.442 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.458 μs)
pycall_legacy! (1, 1, 1)         	TrialEstimate(1.111 μs)
pycall! (1, 1, 1)                	TrialEstimate(1.103 μs)
pycall_legacy (1,)               	TrialEstimate(1.243 μs)
pycall (1,)                      	TrialEstimate(1.257 μs)
pycall_legacy! (1,)              	TrialEstimate(982.904 ns)
pycall! (1,)                     	TrialEstimate(1.049 μs)
pycall_legacy ()                 	TrialEstimate(526.279 ns)
pycall ()                        	TrialEstimate(553.438 ns)
pycall_legacy! ()                	TrialEstimate(407.504 ns)
pycall! ()                       	TrialEstimate(450.710 ns)

Median times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(1.475 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.603 μs)
pycall_legacy! 7*(1,1,...)       	TrialEstimate(1.253 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.254 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(1.251 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.239 μs)
pycall_legacy! (1, 1, 1)         	TrialEstimate(989.923 ns)
pycall! (1, 1, 1)                	TrialEstimate(1.007 μs)
pycall_legacy (1,)               	TrialEstimate(1.160 μs)
pycall (1,)                      	TrialEstimate(1.072 μs)
pycall_legacy! (1,)              	TrialEstimate(874.203 ns)
pycall! (1,)                     	TrialEstimate(915.019 ns)
pycall_legacy ()                 	TrialEstimate(408.221 ns)
pycall ()                        	TrialEstimate(439.067 ns)
pycall_legacy! ()                	TrialEstimate(362.600 ns)
pycall! ()                       	TrialEstimate(392.510 ns)

I think the difference is in the current pycall there are 2 (nested) try finally blocks
in `_pycall!(ret::PyObject, o::Union{PyObject,PyPtr}, args, nargs::Int=length(args),
                  kw::Union{Ptr{Cvoid}, PyObject}=C_NULL)`
which calls `__pycall!(ret::PyObject, pyargsptr::PyPtr, o::Union{PyObject,PyPtr},
  kw::Union{Ptr{Cvoid}, PyObject})`
--------------------------------------------------------------------------------
6)
a) no map, i.e. just `pyarg = PyObject(args[i])` instead of `oargs = map(PyObject, args)`
b) unsplat args, kwargs
c) removal of `ret::PyObject` return value type assert
d) pyargsptr as ptr not object
e) plus pycall_legacy!
f) plus move sigatomic stuff and try finally, out of `__pycall`

Mean times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(1.901 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.481 μs)
pycall_legacy! 7*(1,1,...)       	TrialEstimate(1.521 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.401 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(1.265 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.278 μs)
pycall_legacy! (1, 1, 1)         	TrialEstimate(1.216 μs)
pycall! (1, 1, 1)                	TrialEstimate(1.188 μs)
pycall_legacy (1,)               	TrialEstimate(1.131 μs)
pycall (1,)                      	TrialEstimate(1.136 μs)
pycall_legacy! (1,)              	TrialEstimate(1.040 μs)
pycall! (1,)                     	TrialEstimate(951.035 ns)
pycall_legacy ()                 	TrialEstimate(536.222 ns)
pycall ()                        	TrialEstimate(534.876 ns)
pycall_legacy! ()                	TrialEstimate(433.034 ns)
pycall! ()                       	TrialEstimate(400.614 ns)

Median times
----------
pycall_legacy 7*(1,1,...)        	TrialEstimate(1.660 μs)
pycall 7*(1,1,...)               	TrialEstimate(1.321 μs)
pycall_legacy! 7*(1,1,...)       	TrialEstimate(1.296 μs)
pycall! 7*(1,1,...)              	TrialEstimate(1.218 μs)
pycall_legacy (1, 1, 1)          	TrialEstimate(1.165 μs)
pycall (1, 1, 1)                 	TrialEstimate(1.132 μs)
pycall_legacy! (1, 1, 1)         	TrialEstimate(1.063 μs)
pycall! (1, 1, 1)                	TrialEstimate(1.023 μs)
pycall_legacy (1,)               	TrialEstimate(1.023 μs)
pycall (1,)                      	TrialEstimate(982.841 ns)
pycall_legacy! (1,)              	TrialEstimate(943.795 ns)
pycall! (1,)                     	TrialEstimate(862.812 ns)
pycall_legacy ()                 	TrialEstimate(423.973 ns)
pycall ()                        	TrialEstimate(410.929 ns)
pycall_legacy! ()                	TrialEstimate(381.956 ns)
pycall! ()                       	TrialEstimate(362.243 ns)


--------------------------------------------------------------------------------
Gym ablations

N.B. all results under a cloud since relied on Revise, and results differed when I manually
restarted the jl kernel

Gym time pre removal of try catch

env.name = "Pong-v4"
t = 1.050384498
steps = 2205
(t * 1.0e6) / steps = 476.36485170068033
------------------------------
env.name = "PongNoFrameskip-v4"
t = 1.335524815
steps = 6779
(t * 1.0e6) / steps = 197.00911860156367
------------------------------
env.name = "CartPole-v0"
t = 0.915578464
steps = 95057
(t * 1.0e6) / steps = 9.631888908760008
------------------------------
env.name = "CartPole-v0"
t = 0.665311923
steps = 41895
(t * 1.0e6) / steps = 15.880461224489794
------------------------------
env.name = "Blackjack-v0"
t = 0.880825169
steps = 21360
(t * 1.0e6) / steps = 41.237133380149814
------------------------------
env.name = "RoboschoolHalfCheetah-v1"
t = 0.887696678
steps = 438
(t * 1.0e6) / steps = 2026.7047442922374
------------------------------


--------------------------------------------------------------------------------
post removal of try-catch (minimal difference)

env.name = "Pong-v4"
num_eps = 4
t = 2.257973231
steps = 4745
t*1e6/steps (lower is better): 475.86369462592194
------------------------------
env.name = "PongNoFrameskip-v4"
num_eps = 3
t = 2.028632763
steps = 10176
t*1e6/steps (lower is better): 199.3546347287736
------------------------------
env.name = "CartPole-v0"
num_eps = 6910
t = 1.489368876
steps = 153335
t*1e6/steps (lower is better): 9.713169700329344
------------------------------
env.name = "CartPole-v0"
num_eps = 5159
t = 1.844753363
steps = 116279
t*1e6/steps (lower is better): 15.864888440733063
------------------------------
env.name = "Blackjack-v0"
num_eps = 19571
t = 1.07753114
steps = 26966
t*1e6/steps (lower is better): 39.95887932952608
------------------------------
env.name = "RoboschoolHalfCheetah-v1"
num_eps = 52
t = 1.879571226
steps = 946
t*1e6/steps (lower is better): 1986.8617610993658
------------------------------

--------------------------------------------------------------------------------
post removal of try-catch (minimal difference)
+ manual PyObject! conversion of action (minimal difference)

env.name = "Pong-v4"
num_eps = 4
t = 2.346446952
steps = 4911
t*1e6/steps (lower is better): 477.79412583995116
------------------------------
env.name = "PongNoFrameskip-v4"
num_eps = 3
t = 2.046163357
steps = 10315
t*1e6/steps (lower is better): 198.36775152690257
------------------------------
env.name = "CartPole-v0"
num_eps = 11413
t = 2.352766361
steps = 253557
t*1e6/steps (lower is better): 9.279043217107002
------------------------------
env.name = "CartPole-v0"
num_eps = 4442
t = 1.55463788
steps = 98786
t*1e6/steps (lower is better): 15.737431214949488
------------------------------
env.name = "Blackjack-v0"
num_eps = 22140
t = 1.224960864
steps = 30354
t*1e6/steps (lower is better): 40.35583000593003
------------------------------
env.name = "RoboschoolHalfCheetah-v1"
num_eps = 53
t = 1.926679823
steps = 968
t*1e6/steps (lower is better): 1990.3717179752064
------------------------------

--------------------------------------------------------------------------------
post removal of try-catch (minimal difference)
no pycall!
yes set_data!

env.name = "Pong-v4"
num_eps = 4
t = 2.571392841
tadjusted = 2.540070125
steps = 5177
t*1e6/steps (lower is better): 490.64518543558046
------------------------------
env.name = "PongNoFrameskip-v4"
num_eps = 3
t = 2.861455163
tadjusted = 2.839137479
steps = 10760
t*1e6/steps (lower is better): 263.86036050185874
------------------------------
env.name = "CartPole-v0"
num_eps = 8983
t = 2.310923566
tadjusted = 1.388935395
steps = 200175
t*1e6/steps (lower is better): 6.93860569501686
------------------------------
env.name = "CartPole-v0"
num_eps = 5849
t = 2.534395529
tadjusted = 2.4180355230000004
steps = 130237
t*1e6/steps (lower is better): 18.566425232460826
------------------------------
env.name = "Blackjack-v0"
num_eps = 26974
t = 1.547618561
tadjusted = 0.6321479749999999
steps = 37034
t*1e6/steps (lower is better): 17.069395015391258
------------------------------
env.name = "RoboschoolHalfCheetah-v1"
num_eps = 66
t = 2.370617681
tadjusted = 2.081434325
steps = 1150
t*1e6/steps (lower is better): 1809.9428913043478
------------------------------

makes a difference

--------------------------------------------------------------------------------
post removal of try-catch (minimal difference)
no pycall!
no `set_data!(...)` replaced with `env.state = PyArray(env.pystate)`

env.name = "Pong-v4"
num_eps = 4
t = 3.029195366
tadjusted = 2.9979612380000003
steps = 5211
t*1e6/steps (lower is better): 575.3139969295721
------------------------------
env.name = "PongNoFrameskip-v4"
num_eps = 3
t = 2.68979637
tadjusted = 2.664569964
steps = 9965
t*1e6/steps (lower is better): 267.3928714500753
------------------------------
env.name = "CartPole-v0"
num_eps = 6972
t = 2.734460922
tadjusted = 2.6166898979999997
steps = 155447
t*1e6/steps (lower is better): 16.833325171923548
------------------------------
env.name = "CartPole-v0"
num_eps = 5250
t = 1.80031712
tadjusted = 1.6914636200000002
steps = 117729
t*1e6/steps (lower is better): 14.36743385232186
------------------------------
env.name = "Blackjack-v0"
num_eps = 31945
t = 1.906058517
tadjusted = 0.638161467
steps = 43934
t*1e6/steps (lower is better): 14.525457891382526
------------------------------
env.name = "RoboschoolHalfCheetah-v1"
num_eps = 42
t = 1.527341287
tadjusted = 1.383843415
steps = 737
t*1e6/steps (lower is better): 1877.6708480325644
------------------------------

about 20-25% slower than regular? similar to removing using pycall instead of pycall!

--------------------------------------------------------------------------------
post removal of try-catch (minimal difference)
with pycall!
no `set_data!(...)` replaced with `env.state = PyArray(env.pystate)`

env.name = "Pong-v4"
num_eps = 4
t = 2.646357844
tadjusted = 2.6137432
steps = 5175
t*1e6/steps (lower is better): 505.07114975845417
------------------------------
env.name = "PongNoFrameskip-v4"
num_eps = 3
t = 3.080105803
tadjusted = 3.0487793499999998
steps = 10904
t*1e6/steps (lower is better): 279.6019213132795
------------------------------
env.name = "CartPole-v0"
num_eps = 11797
t = 4.285182145
tadjusted = 4.099768696
steps = 264394
t*1e6/steps (lower is better): 15.50628492325847
------------------------------
env.name = "CartPole-v0"
num_eps = 6620
t = 2.463092475
tadjusted = 2.335995095
steps = 147858
t*1e6/steps (lower is better): 15.798909054633498
------------------------------
env.name = "Blackjack-v0"
num_eps = 35854
t = 2.128675045
tadjusted = 0.8667576610000001
steps = 49506
t*1e6/steps (lower is better): 17.50813357976811
------------------------------
env.name = "RoboschoolHalfCheetah-v1"
num_eps = 37
t = 1.393248751
tadjusted = 1.249845816
steps = 672
t*1e6/steps (lower is better): 1859.8896071428574
------------------------------

--------------------------------------------------------------------------------
no pycall!
no `set_data!(...)` replaced with `env.state = PyArray(env.pystate)`
yes fast tuple access

env.name = "Pong-v4"
num_eps = 4
t = 2.628382774
steps = 5035
t*1e6/steps (lower is better): 522.0223980139026
------------------------------
env.name = "PongNoFrameskip-v4"
num_eps = 4
t = 3.518615167
steps = 13267
t*1e6/steps (lower is better): 265.21558506067686
------------------------------
env.name = "MsPacman-v4"
num_eps = 9
t = 3.310728808
steps = 5722
t*1e6/steps (lower is better): 578.5964362111149
------------------------------
env.name = "MsPacmanNoFrameskip-v4"
num_eps = 9
t = 5.183118162
steps = 17753
t*1e6/steps (lower is better): 291.9573121162621
------------------------------

--------------------------------------------------------------------------------
no pycall!
yes `set_data!(...)` replaced with `env.state = PyArray(env.pystate)`

env.name = "Pong-v4"
num_eps = 4
t = 2.551205445
tadjusted = 2.519311073
steps = 4946
t*1e6/steps (lower is better): 509.363338657501
------------------------------
env.name = "PongNoFrameskip-v4"
num_eps = 3
t = 2.725730319
tadjusted = 2.700133842
steps = 10980
t*1e6/steps (lower is better): 245.91382896174866
------------------------------

--------------------------------------------------------------------------------
no pycall!
no `set_data!(...)` replaced with `env.state = PyArray(env.pystate)`
no fast tuple access

env.name = "Pong-v4"
num_eps = 4
t = 2.819671811
steps = 5013
t*1e6/steps (lower is better): 562.4719351685618
------------------------------
env.name = "PongNoFrameskip-v4"
num_eps = 4
t = 3.9855366099999996
steps = 14366
t*1e6/steps (lower is better): 277.42841500765695
------------------------------
env.name = "MsPacman-v4"
num_eps = 9
t = 2.8329333169999997
steps = 4993
t*1e6/steps (lower is better): 567.3809967955136
------------------------------
env.name = "MsPacmanNoFrameskip-v4"
num_eps = 9
t = 5.618259107000001
steps = 17593
t*1e6/steps (lower is better): 319.34628016824877
------------------------------












---
