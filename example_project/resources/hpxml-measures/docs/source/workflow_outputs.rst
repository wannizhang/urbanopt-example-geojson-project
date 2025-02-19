.. _workflow_outputs:

Workflow Outputs
================

OpenStudio-HPXML generates a number of workflow outputs:

  =============================================  ======================================
  File                                           Notes
  =============================================  ======================================
  in.xml                                         See :ref:`hpxml_defaults`. HPXML file populated with defaulted values (e.g., autosized HVAC capacities).
  in.idf                                         EnergyPlus input file.
  in.osm                                         OpenStudio model file. Only generated if the ``debug`` argument is used.
  results_annual.csv (or .json or .msgpack)      See :ref:`annual_outputs`. Simulation annual outputs in CSV or JSON format.
  results_timeseries.csv (or .json or .msgpack)  See :ref:`timeseries_outputs`. Simulation timeseries outputs in CSV or JSON format. Only generated if requested.
  results_hpxml.csv (or .json or .msgpack)       See :ref:`hpxml_outputs`. HPXML outputs in CSV or JSON format (e.g., enclosure summary, autosized HVAC capacities, design loads, etc.).
  results_bills.csv (or .json or .msgpack)       See :ref:`bill_outputs`. Utility bill outputs in CSV or JSON format.
  run.log                                        Errors/warnings generated by the OpenStudio-HPXML workflow.
  eplusout.*                                     EnergyPlus output files (e.g., msgpack output, error log). Defaults to a subset of possible files; use ``debug`` to produce ALL files.
  =============================================  ======================================

.. _hpxml_defaults:

HPXML Defaults
--------------

OpenStudio-HPXML will always generate an HPXML file called ``in.xml``, located in the run directory.
This file reflects the HPXML input file provided by the user but includes any default values that OpenStudio-HPXML has used.
These default values will all be tagged with the ``dataSource='software'`` attribute.

For example, suppose a central air conditioner is described in the HPXML input file like so:

.. code-block:: XML

  <HVACPlant>
    <CoolingSystem>
      <SystemIdentifier id='CoolingSystem1'/>
      <DistributionSystem idref='HVACDistribution1'/>
      <CoolingSystemType>central air conditioner</CoolingSystemType>
      <CoolingSystemFuel>electricity</CoolingSystemFuel>
      <FractionCoolLoadServed>1.0</FractionCoolLoadServed>
      <AnnualCoolingEfficiency>
        <Units>SEER</Units>
        <Value>13.0</Value>
      </AnnualCoolingEfficiency>
    </CoolingSystem>
  </HVACPlant>

The ``in.xml`` output file will include autosized HVAC capacities as well as some other details:

.. code-block:: XML
 
  <HVACPlant>
    <CoolingSystem>
      <SystemIdentifier id='CoolingSystem1'/>
      <DistributionSystem idref='HVACDistribution1'/>
      <CoolingSystemType>central air conditioner</CoolingSystemType>
      <CoolingSystemFuel>electricity</CoolingSystemFuel>
      <CoolingCapacity dataSource='software'>18773.0</CoolingCapacity>
      <CompressorType dataSource='software'>single stage</CompressorType>
      <FractionCoolLoadServed>1.0</FractionCoolLoadServed>
      <AnnualCoolingEfficiency>
        <Units>SEER</Units>
        <Value>13.0</Value>
      </AnnualCoolingEfficiency>
      <SensibleHeatFraction dataSource='software'>0.73</SensibleHeatFraction>
      <extension>
        <AirflowDefectRatio dataSource='software'>0.0</AirflowDefectRatio>
        <ChargeDefectRatio dataSource='software'>0.0</ChargeDefectRatio>
        <FanPowerWattsPerCFM dataSource='software'>0.375</FanPowerWattsPerCFM>
        <CoolingAirflowCFM dataSource='software'>781.0</CoolingAirflowCFM>
      </extension>
    </CoolingSystem>
  </HVACPlant>

.. _annual_outputs:

Annual Outputs
--------------

OpenStudio-HPXML will always generate an annual output file called ``results_annual.csv`` (or ``results_annual.json`` or ``results_annual.msgpack``), located in the run directory.
The file includes the following sections of output:

Annual Energy Consumption by Fuel Use
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fuel uses are listed below.

   ====================================  ===========================
   Type                                  Notes
   ====================================  ===========================
   Fuel Use: Electricity: Total (MBtu)
   Fuel Use: Electricity: Net (MBtu)     Subtracts any power produced by PV (including any battery storage) or generators.
   Fuel Use: Natural Gas: Total (MBtu)
   Fuel Use: Fuel Oil: Total (MBtu)      Includes "fuel oil", "fuel oil 1", "fuel oil 2", "fuel oil 4", "fuel oil 5/6", "kerosene", and "diesel"
   Fuel Use: Propane: Total (MBtu)
   Fuel Use: Wood: Total (MBtu)
   Fuel Use: Wood Pellets: Total (MBtu)
   Fuel Use: Coal: Total (MBtu)          Includes "coal", "anthracite coal", "bituminous coal", and "coke".
   ====================================  ===========================

Annual Energy Consumption By End Use
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

End uses are listed below.

Note that all end uses are mutually exclusive -- the "Electricity: Heating" end use, for example, excludes energy reported in the "Electricity: Heating Fans/Pumps" end use.
So the sum of all end uses for a given fuel (e.g., sum of all "End Use: Natural Gas: \*") equal the above reported fuel use (e.g., "Fuel Use: Natural Gas: Total").

   ===================================================================  ====================================================
   Type                                                                 Notes
   ===================================================================  ====================================================
   End Use: Electricity: Heating (MBtu)                                 Excludes heat pump backup and fans/pumps
   End Use: Electricity: Heating Heat Pump Backup (MBtu)
   End Use: Electricity: Heating Fans/Pumps (MBtu)
   End Use: Electricity: Cooling (MBtu)                                 Excludes fans/pumps
   End Use: Electricity: Cooling Fans/Pumps (MBtu)
   End Use: Electricity: Hot Water (MBtu)                               Excludes recirc pump and solar thermal pump
   End Use: Electricity: Hot Water Recirc Pump (MBtu)
   End Use: Electricity: Hot Water Solar Thermal Pump (MBtu)            Non-zero only when using detailed (not simple) solar thermal inputs
   End Use: Electricity: Lighting Interior (MBtu)
   End Use: Electricity: Lighting Garage (MBtu)
   End Use: Electricity: Lighting Exterior (MBtu)
   End Use: Electricity: Mech Vent (MBtu)                               Excludes preheating/precooling
   End Use: Electricity: Mech Vent Preheating (MBtu)
   End Use: Electricity: Mech Vent Precooling (MBtu)
   End Use: Electricity: Whole House Fan (MBtu)
   End Use: Electricity: Refrigerator (MBtu)
   End Use: Electricity: Freezer (MBtu)
   End Use: Electricity: Dehumidifier (MBtu)
   End Use: Electricity: Dishwasher (MBtu)
   End Use: Electricity: Clothes Washer (MBtu)
   End Use: Electricity: Clothes Dryer (MBtu)
   End Use: Electricity: Range/Oven (MBtu)
   End Use: Electricity: Ceiling Fan (MBtu)
   End Use: Electricity: Television (MBtu)
   End Use: Electricity: Plug Loads (MBtu)                              Excludes independently reported plug loads (e.g., well pump)
   End Use: Electricity: Electric Vehicle Charging (MBtu)
   End Use: Electricity: Well Pump (MBtu)
   End Use: Electricity: Pool Heater (MBtu)
   End Use: Electricity: Pool Pump (MBtu)
   End Use: Electricity: Hot Tub Heater (MBtu)
   End Use: Electricity: Hot Tub Pump (MBtu)
   End Use: Electricity: PV (MBtu)                                      Negative value for any power produced (including any battery storage)
   End Use: Electricity: Generator (MBtu)                               Negative value for any power produced
   End Use: Natural Gas: Heating (MBtu)                                 Excludes heat pump backup
   End Use: Natural Gas: Heating Heat Pump Backup (MBtu)
   End Use: Natural Gas: Hot Water (MBtu)
   End Use: Natural Gas: Clothes Dryer (MBtu)
   End Use: Natural Gas: Range/Oven (MBtu)
   End Use: Natural Gas: Mech Vent Preheating (MBtu)
   End Use: Natural Gas: Mech Vent Precooling (MBtu)
   End Use: Natural Gas: Pool Heater (MBtu)
   End Use: Natural Gas: Hot Tub Heater (MBtu)
   End Use: Natural Gas: Grill (MBtu)
   End Use: Natural Gas: Lighting (MBtu)
   End Use: Natural Gas: Fireplace (MBtu)
   End Use: Natural Gas: Generator (MBtu)                               Positive value for any fuel consumed
   End Use: Fuel Oil: Heating (MBtu)                                    Excludes heat pump backup
   End Use: Fuel Oil: Heating Heat Pump Backup (MBtu)
   End Use: Fuel Oil: Hot Water (MBtu)
   End Use: Fuel Oil: Clothes Dryer (MBtu)
   End Use: Fuel Oil: Range/Oven (MBtu)
   End Use: Fuel Oil: Mech Vent Preheating (MBtu)
   End Use: Fuel Oil: Mech Vent Precooling (MBtu)
   End Use: Fuel Oil: Grill (MBtu)
   End Use: Fuel Oil: Lighting (MBtu)
   End Use: Fuel Oil: Fireplace (MBtu)
   End Use: Propane: Heating (MBtu)                                     Excludes heat pump backup
   End Use: Propane: Heating Heat Pump Backup (MBtu)
   End Use: Propane: Hot Water (MBtu)
   End Use: Propane: Clothes Dryer (MBtu)
   End Use: Propane: Range/Oven (MBtu)
   End Use: Propane: Mech Vent Preheating (MBtu)
   End Use: Propane: Mech Vent Precooling (MBtu)
   End Use: Propane: Grill (MBtu)
   End Use: Propane: Lighting (MBtu)
   End Use: Propane: Fireplace (MBtu)
   End Use: Propane: Generator (MBtu)                                   Positive value for any fuel consumed
   End Use: Wood Cord: Heating (MBtu)                                   Excludes heat pump backup
   End Use: Wood Cord: Heating Heat Pump Backup (MBtu)
   End Use: Wood Cord: Hot Water (MBtu)
   End Use: Wood Cord: Clothes Dryer (MBtu)
   End Use: Wood Cord: Range/Oven (MBtu)
   End Use: Wood Cord: Mech Vent Preheating (MBtu)
   End Use: Wood Cord: Mech Vent Precooling (MBtu)
   End Use: Wood Cord: Grill (MBtu)
   End Use: Wood Cord: Lighting (MBtu)
   End Use: Wood Cord: Fireplace (MBtu)
   End Use: Wood Pellets: Heating (MBtu)                                Excludes heat pump backup
   End Use: Wood Pellets: Heating Heat Pump Backup (MBtu)
   End Use: Wood Pellets: Hot Water (MBtu)
   End Use: Wood Pellets: Clothes Dryer (MBtu)
   End Use: Wood Pellets: Range/Oven (MBtu)
   End Use: Wood Pellets: Mech Vent Preheating (MBtu)
   End Use: Wood Pellets: Mech Vent Precooling (MBtu)
   End Use: Wood Pellets: Grill (MBtu)
   End Use: Wood Pellets: Lighting (MBtu)
   End Use: Wood Pellets: Fireplace (MBtu)
   End Use: Coal: Heating (MBtu)                                        Excludes heat pump backup
   End Use: Coal: Heating Heat Pump Backup (MBtu)
   End Use: Coal: Hot Water (MBtu)
   End Use: Coal: Clothes Dryer (MBtu)
   End Use: Coal: Range/Oven (MBtu)
   End Use: Coal: Mech Vent Preheating (MBtu)
   End Use: Coal: Mech Vent Precooling (MBtu)
   End Use: Coal: Grill (MBtu)
   End Use: Coal: Lighting (MBtu)
   End Use: Coal: Fireplace (MBtu)
   ===================================================================  ====================================================

Annual Emissions
~~~~~~~~~~~~~~~~

Results for each emissions scenario defined in the HPXML file is listed as shown below.

   ==============================================================  ==================================================================
   Type                                                            Notes
   ==============================================================  ==================================================================
   Emissions: <EmissionsType>: <Scenario1Name>: Total (lb)         Scenario 1 total emissions
   Emissions: <EmissionsType>: <Scenario1Name>: Electricity (lb)   Scenario 1 emissions for Electricity only
   Emissions: <EmissionsType>: <Scenario1Name>: Natural Gas (lb)   Scenario 1 emissions for Natural Gas only
   Emissions: <EmissionsType>: <Scenario1Name>: Fuel Oil (lb)      Scenario 1 emissions for Fuel Oil only
   Emissions: <EmissionsType>: <Scenario1Name>: Propane (lb)       Scenario 1 emissions for Propane only
   Emissions: <EmissionsType>: <Scenario1Name>: Wood Cord (lb)     Scenario 1 emissions for Wood Cord only
   Emissions: <EmissionsType>: <Scenario1Name>: Wood Pellets (lb)  Scenario 1 emissions for Wood Pellets only
   Emissions: <EmissionsType>: <Scenario1Name>: Coal (lb)          Scenario 1 emissions for Coal only
   Emissions: <EmissionsType>: <Scenario2Name>: Total (lb)         Scenario 2 total emissions
   Emissions: <EmissionsType>: <Scenario2Name>: Electricity (lb)   Scenario 2 emissions for Electricity only
   Emissions: <EmissionsType>: <Scenario2Name>: Natural Gas (lb)   Scenario 2 emissions for Natural Gas only
   Emissions: <EmissionsType>: <Scenario2Name>: Fuel Oil (lb)      Scenario 2 emissions for Fuel Oil only
   Emissions: <EmissionsType>: <Scenario2Name>: Propane (lb)       Scenario 2 emissions for Propane only
   Emissions: <EmissionsType>: <Scenario2Name>: Wood Cord (lb)     Scenario 2 emissions for Wood Cord only
   Emissions: <EmissionsType>: <Scenario2Name>: Wood Pellets (lb)  Scenario 2 emissions for Wood Pellets only
   Emissions: <EmissionsType>: <Scenario2Name>: Coal (lb)          Scenario 2 emissions for Coal only
   ...
   ==============================================================  ==================================================================

Annual Building Loads
~~~~~~~~~~~~~~~~~~~~~

Annual building loads are listed below.

   =====================================  ==================================================================
   Type                                   Notes
   =====================================  ==================================================================
   Load: Heating: Delivered (MBtu)        Includes HVAC distribution losses.
   Load: Cooling: Delivered (MBtu)        Includes HVAC distribution losses.
   Load: Hot Water: Delivered (MBtu)      Includes contributions by desuperheaters or solar thermal systems.
   Load: Hot Water: Tank Losses (MBtu)
   Load: Hot Water: Desuperheater (MBtu)  Load served by the desuperheater.
   Load: Hot Water: Solar Thermal (MBtu)  Load served by the solar thermal system.
   =====================================  ==================================================================

Note that the "Delivered" loads represent the energy delivered by the HVAC/DHW system; if a system is significantly undersized, there will be unmet load not reflected by these values.

Annual Unmet Hours
~~~~~~~~~~~~~~~~~~

Annual unmet hours are listed below.

   =========================  =====
   Type                       Notes
   =========================  =====
   Unmet Hours: Heating (hr)  Number of hours where the heating setpoint is not maintained.
   Unmet Hours: Cooling (hr)  Number of hours where the cooling setpoint is not maintained.
   =========================  =====

These numbers reflect the number of hours of the year when the conditioned space temperature is more than 0.2 deg-C (0.36 deg-F) from the setpoint during heating/cooling.

Peak Building Electricity
~~~~~~~~~~~~~~~~~~~~~~~~~

Peak building electricity outputs are listed below.

   ==================================  =========================================================
   Type                                Notes
   ==================================  =========================================================
   Peak Electricity: Winter Total (W)  Winter season defined by operation of the heating system.
   Peak Electricity: Summer Total (W)  Summer season defined by operation of the cooling system.
   ==================================  =========================================================

Peak Building Loads
~~~~~~~~~~~~~~~~~~~

Peak building loads are listed below.

   ====================================  ==================================
   Type                                  Notes
   ====================================  ==================================
   Peak Load: Heating: Delivered (kBtu)  Includes HVAC distribution losses.
   Peak Load: Cooling: Delivered (kBtu)  Includes HVAC distribution losses.
   ====================================  ==================================

Note that the "Delivered" peak loads represent the energy delivered by the HVAC system; if a system is significantly undersized, there will be unmet peak load not reflected by these values.

Annual Component Building Loads
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Note**: This section is only available if the ``--add-component-loads`` argument is used.
The argument is not used by default for faster performance.

Component loads represent the estimated contribution of different building components to the annual heating/cooling building loads.
The sum of component loads for heating (or cooling) will roughly equal the annual heating (or cooling) building load reported above.

Component loads disaggregated by Heating/Cooling are listed below.
   
   =================================================  =========================================================================================================
   Type                                               Notes
   =================================================  =========================================================================================================
   Component Load: \*: Roofs (MBtu)                   Heat gain/loss through HPXML ``Roof`` elements adjacent to conditioned space
   Component Load: \*: Ceilings (MBtu)                Heat gain/loss through HPXML ``FrameFloor`` elements (inferred to be ceilings) adjacent to conditioned space
   Component Load: \*: Walls (MBtu)                   Heat gain/loss through HPXML ``Wall`` elements adjacent to conditioned space
   Component Load: \*: Rim Joists (MBtu)              Heat gain/loss through HPXML ``RimJoist`` elements adjacent to conditioned space
   Component Load: \*: Foundation Walls (MBtu)        Heat gain/loss through HPXML ``FoundationWall`` elements adjacent to conditioned space
   Component Load: \*: Doors (MBtu)                   Heat gain/loss through HPXML ``Door`` elements adjacent to conditioned space
   Component Load: \*: Windows (MBtu)                 Heat gain/loss through HPXML ``Window`` elements adjacent to conditioned space, including solar
   Component Load: \*: Skylights (MBtu)               Heat gain/loss through HPXML ``Skylight`` elements adjacent to conditioned space, including solar
   Component Load: \*: Floors (MBtu)                  Heat gain/loss through HPXML ``FrameFloor`` elements (inferred to be floors) adjacent to conditioned space
   Component Load: \*: Slabs (MBtu)                   Heat gain/loss through HPXML ``Slab`` elements adjacent to conditioned space
   Component Load: \*: Internal Mass (MBtu)           Heat gain/loss from internal mass (e.g., furniture, interior walls/floors) in conditioned space
   Component Load: \*: Infiltration (MBtu)            Heat gain/loss from airflow induced by stack and wind effects
   Component Load: \*: Natural Ventilation (MBtu)     Heat gain/loss from airflow through operable windows
   Component Load: \*: Mechanical Ventilation (MBtu)  Heat gain/loss from airflow/fan energy from mechanical ventilation systems (including clothes dryer exhaust)
   Component Load: \*: Whole House Fan (MBtu)         Heat gain/loss from airflow due to a whole house fan
   Component Load: \*: Ducts (MBtu)                   Heat gain/loss from conduction and leakage losses through supply/return ducts outside conditioned space
   Component Load: \*: Internal Gains (MBtu)          Heat gain/loss from appliances, lighting, plug loads, water heater tank losses, etc. in the conditioned space
   =================================================  =========================================================================================================

Annual Hot Water Uses
~~~~~~~~~~~~~~~~~~~~~

Annual hot water uses are listed below.

   ===================================  ====================
   Type                                 Notes
   ===================================  ====================
   Hot Water: Clothes Washer (gal)
   Hot Water: Dishwasher (gal)
   Hot Water: Fixtures (gal)            Showers and faucets.
   Hot Water: Distribution Waste (gal) 
   ===================================  ====================

.. _timeseries_outputs:

Timeseries Outputs
------------------

OpenStudio-HPXML can optionally generate a timeseries output file.
The timeseries output file is called ``results_timeseries.csv`` (or ``results_timeseries.json`` or ``results_timeseries.msgpack``) and located in the run directory.

Depending on the outputs requested, the file may include:

   ===================================  ==================================================================================================================================
   Type                                 Notes
   ===================================  ==================================================================================================================================
   Total Consumptions                   Energy use for building total.
   Fuel Consumptions                    Energy use for each fuel type (in kBtu for fossil fuels and kWh for electricity).
   End Use Consumptions                 Energy use for each end use type (in kBtu for fossil fuels and kWh for electricity).
   Emissions                            Emissions (e.g., CO2) for each scenario defined in the HPXML file.
   Hot Water Uses                       Water use for each end use type (in gallons).
   Total Loads                          Heating, cooling, and hot water loads (in kBtu) for the building.
   Component Loads                      Heating and cooling loads (in kBtu) disaggregated by component (e.g., Walls, Windows, Infiltration, Ducts, etc.).
   Zone Temperatures                    Average temperatures (in deg-F) for each space modeled (e.g., living space, attic, garage, basement, crawlspace, etc.).
   Airflows                             Airflow rates (in cfm) for infiltration, mechanical ventilation (including clothes dryer exhaust), natural ventilation, whole house fans.
   Weather                              Weather file data including outdoor temperatures, relative humidity, wind speed, and solar.
   EnergyPlus Output Variables          These are optional and can be requested with the ReportSimulationOutput ``user_output_variables`` argument.
   ===================================  ==================================================================================================================================

Timeseries outputs can be one of the following frequencies: hourly, daily, monthly, or timestep (i.e., equal to the simulation timestep, which defaults to an hour but can be sub-hourly).

Timestamps in the output use the end-of-hour (or end-of-day for daily frequency, etc.) convention.
Additional timestamp columns can be optionally requested that reflect daylight saving time (DST) and/or coordinated universal time (UTC).
Most outputs will be summed over the hour (e.g., energy) but some will be averaged over the hour (e.g., temperatures, airflows).

.. _hpxml_outputs:

HPXML Outputs
-------------

OpenStudio-HPXML will always generate an output file called ``results_hpxml.csv`` (or ``results_hpxml.json`` or ``results_hpxml.msgpack``), located in the run directory.
Unlike the other output files that are based on EnergyPlus simulation results, this file contains outputs summarizing the HPXML file (including defaults like auto-sized HVAC systems).
The file includes the following sections of output:

Enclosure
~~~~~~~~~

Enclosure outputs are listed below.

   =======================================================  ====================
   Type                                                     Notes
   =======================================================  ====================
   Enclosure: Wall Area Thermal Boundary (ft^2)             Total thermal boundary wall area
   Enclosure: Wall Area Exterior (ft^2)                     Total exterior wall area
   Enclosure: Foundation Wall Area Exterior (ft^2)          Total exterior foundation wall area
   Enclosure: Floor Area Conditioned (ft^2)                 Total conditioned floor area
   Enclosure: Floor Area Lighting (ft^2)                    Total lighting floor area
   Enclosure: Floor Area Foundation (ft^2)                  Total foundation floor area
   Enclosure: Ceiling Area Thermal Boundary (ft^2)          Total thermal boundary ceiling area
   Enclosure: Roof Area (ft^2)                              Total roof area
   Enclosure: Window Area (ft^2)                            Total window area
   Enclosure: Door Area (ft^2)                              Total door area
   Enclosure: Duct Area Unconditioned (ft^2)                Total unconditioned duct area
   Enclosure: Rim Joist Area (ft^2)                         Total rim joist area
   Enclosure: Slab Exposed Perimeter Thermal Boundary (ft)  Total thermal boundary slab exposed perimeter
   =======================================================  ====================

Systems
~~~~~~~

System outputs are listed below.
Autosized HVAC systems are based on ACCA Manual S calculations.

   =======================================================  ====================
   Type                                                     Notes
   =======================================================  ====================
   Systems: Cooling Capacity (Btu/h)                        Total HVAC cooling capacity
   Systems: Heating Capacity (Btu/h)                        Total HVAC heating capacity
   Systems: Heat Pump Backup Capacity (Btu/h)               Total HVAC heat pump backup capacity
   Systems: Water Heater Tank Volume (gal)                  Total water heater tank volume
   Systems: Mechanical Ventilation Flow Rate (cfm)          Total mechanical ventilation flow rate
   =======================================================  ====================

If the HPXML file has ``Systems/HVAC/HVACPlant/PrimarySystems`` populated, then additional system outputs will be provided:

   =======================================================  ====================
   Type                                                     Notes
   =======================================================  ====================
   Primary Systems: Cooling Capacity (Btu/h)                Cooling capacity of primary system
   Primary Systems: Heating Capacity (Btu/h)                Heating capacity of primary system
   Primary Systems: Heat Pump Backup Capacity (Btu/h)       Heat pump backup capacity of primary system
   Secondary Systems: Cooling Capacity (Btu/h)              Cooling capacity of secondary system; only provided if a non-primary system is present
   Secondary Systems: Heating Capacity (Btu/h)              Heating capacity of secondary system; only provided if a non-primary system is present
   Secondary Systems: Heat Pump Backup Capacity (Btu/h)     Heat pump backup capacity of secondary system; only provided if a non-primary system is present
   =======================================================  ====================

Design Loads
~~~~~~~~~~~~

Design load outputs are listed below.
Design loads are based on block load ACCA Manual J calculations.

   ================================================================  ====================
   Type                                                              Notes
   ================================================================  ====================
   Design Loads Heating: Total (Btu/h)                               Total heating design load
   Design Loads Heating: Ducts (Btu/h)                               Heating design load for ducts
   Design Loads Heating: Windows (Btu/h)                             Heating design load for windows
   Design Loads Heating: Skylights (Btu/h)                           Heating design load for skylights
   Design Loads Heating: Doors (Btu/h)                               Heating design load for doors
   Design Loads Heating: Walls (Btu/h)                               Heating design load for walls
   Design Loads Heating: Roofs (Btu/h)                               Heating design load for roofs
   Design Loads Heating: Floors (Btu/h)                              Heating design load for floors
   Design Loads Heating: Slabs (Btu/h)                               Heating design load for slabs
   Design Loads Heating: Ceilings (Btu/h)                            Heating design load for ceilings
   Design Loads Heating: Infiltration/Ventilation (Btu/h)            Heating design load for infiltration/ventilation
   Design Loads Cooling Sensible: Total (Btu/h)                      Total sensible cooling design load
   Design Loads Cooling Sensible: Ducts (Btu/h)                      Sensible cooling design load for ducts
   Design Loads Cooling Sensible: Windows (Btu/h)                    Sensible cooling design load for windows
   Design Loads Cooling Sensible: Skylights (Btu/h)                  Sensible cooling design load for skylights
   Design Loads Cooling Sensible: Doors (Btu/h)                      Sensible cooling design load for doors
   Design Loads Cooling Sensible: Walls (Btu/h)                      Sensible cooling design load for walls
   Design Loads Cooling Sensible: Roofs (Btu/h)                      Sensible cooling design load for roofs
   Design Loads Cooling Sensible: Floors (Btu/h)                     Sensible cooling design load for floors
   Design Loads Cooling Sensible: Slabs (Btu/h)                      Sensible cooling design load for slabs
   Design Loads Cooling Sensible: Ceilings (Btu/h)                   Sensible cooling design load for ceilings
   Design Loads Cooling Sensible: Infiltration/Ventilation (Btu/h)   Sensible cooling design load for infiltration/ventilation
   Design Loads Cooling Sensible: Internal Gains (Btu/h)             Sensible cooling design load for internal gains
   Design Loads Cooling Latent: Total (Btu/h)                        Total latent cooling design load
   Design Loads Cooling Latent: Ducts (Btu/h)                        Latent cooling design load for ducts
   Design Loads Cooling Latent: Infiltration/Ventilation (Btu/h)     Latent cooling design load for infiltration/ventilation
   Design Loads Cooling Latent: Internal Gains (Btu/h)               Latent cooling design load for internal gains
   ================================================================  ====================

.. _bill_outputs:

Utility Bill Outputs
--------------------

OpenStudio-HPXML can optionally generate a utility bills output file.
The utility bills output file is called ``results_bills.csv`` (or ``results_bills.json`` or ``results_bills.msgpack``) and located in the run directory.
Monthly fixed charges and marginal rates, as well as PV compensation types/rates/fees, are defined to determine how utility bills are calculated.

The file includes:

   =============================================  ====================
   Type                                           Notes
   =============================================  ====================
   Total ($)                                      Annual total charges.
   Electricity: Fixed ($)                         Annual fixed charges for electricity.
   Electricity: Marginal ($)                      Annual energy charges for electricity.
   Electricity: PV Credit ($)                     Annual production credit (negative value) for PV.
   Electricity: Total ($)                         Annual total charges for electricity.
   Natural Gas: Fixed ($)                         Annual fixed charges for natural gas.
   Natural Gas: Marginal ($)                      Annual energy charges for natural gas.
   Natural Gas: Total ($)                         Annual total charges for natural gas.
   Fuel Oil: Total ($)                            Annual total charges for fuel oil.
   Propane: Total ($)                             Annual total charges for propane.
   Wood Cord: Total ($)                           Annual total charges for wood cord.
   Wood Pellets: Total ($)                        Annual total charges for wood pellets.
   Coal: Total ($)                                Annual total charges for coal.
   =============================================  ====================
