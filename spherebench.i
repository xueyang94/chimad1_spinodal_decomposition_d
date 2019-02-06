[Mesh]
  file = sphere_mesh.e
  uniform_refine = 7
[]

[Variables]
  [./c]
    order = FIRST
    family = LAGRANGE
    #scaling = 1e+04
  [../]
  [./w]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./f_density]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[ICs]
  [./concentrationIC]
    type = FunctionIC
    function = '0.5 + 0.05 * (cos(8*acos(z/100))*cos(15*atan(y/x)) +
                (cos(12*acos(z/100))*cos(10*atan(y/x)))^2 +
                cos(2.5*acos(z/100) - 1.5*atan(y/x))*cos(7*acos(z/100) - 2*atan(y/x)))'
    variable = c
  [../]
[]

# [BCs]
#   [./Periodic]
#     [./c_bcs]
#       auto_direction = 'x y'
#     [../]
#   [../]
# []

[Kernels]
  [./w_dot]
    type = CoupledTimeDerivative
    v = c
    variable = w
  [../]
  [./coupled_res]
    type = SplitCHWRes
    variable = w
    mob_name = M
  [../]
  [./coupled_parsed]
    type = SplitCHParsed
    variable = c
    f_name = f_loc
    kappa_name = kappa_c
    w = w
  [../]
[]

[AuxKernels]
  [./f_density]
    type = TotalFreeEnergy
    variable = f_density
    f_name = 'f_loc'
    kappa_names = 'kappa_c'
    interfacial_vars = c
  [../]
[]

[Materials]
  [./kappa]
    type = GenericConstantMaterial
    prop_names = 'kappa_c'
    prop_values = '2'
  [../]
  [./mobility]
    type = GenericConstantMaterial
    prop_names = 'M'
    prop_values = '5'
  [../]
  [./local_energy]
    type = DerivativeParsedMaterial
    f_name = f_loc
    args = c
    constant_names = 'q ca cb'
    constant_expressions = '5 0.3 0.7'
    function = 'q*(c - ca)^2 * (cb - c)^2'
    derivative_order = 2
  [../]
  # [./precipitate_indicator]
  #   type = ParsedMaterial
  #   f_name = prec_indic
  #   args = c
  #   function = if(c>0.6,0.0016,0)
  # [../]
[]

[Preconditioning]
  [./coupled]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  l_max_its = 30
  l_tol = 1e-06
  nl_max_its = 50
  nl_abs_tol = 1e-09
  end_time = 604800
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm      31                  preonly       ilu          1'
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 50
    cutback_factor = 0.8
    growth_factor = 1.5
    optimal_iterations = 7
  [../]
  [./Adaptivity]
    coarsen_fraction = 0.1
    refine_fraction = 0.7
    max_h_level = 7
  [../]
[]

[Postprocessors]
  [./total_energy]
    type = ElementIntegralVariablePostprocessor
    variable = f_density
  [../]
  [./physical]
    type = MemoryUsage
    mem_type = physical_memory
    value_type = total
    # by default MemoryUsage reports the peak value for the current timestep
    # out of all samples that have been taken (at linear and non-linear iterations)
    execute_on = 'INITIAL TIMESTEP_END NONLINEAR LINEAR'
  [../]
  # [./walltime]
  #   type = PerformanceData
  #   event = ALIVE
  #   execute_on = 'INITIAL TIMESTEP_END'
  # [../]
[]

[Debug]
  show_var_residual_norms = true
[]

[Outputs]
  exodus = true
  #console = true
  csv = true
  perf_graph = true
  # [./console]
  #   type = Console
  #   max_rows = 10
  # [../]
[]
