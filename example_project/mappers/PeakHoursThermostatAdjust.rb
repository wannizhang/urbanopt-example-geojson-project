# *********************************************************************************
# URBANopt™, Copyright (c) 2019-2022, Alliance for Sustainable Energy, LLC, and other
# contributors. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this list
# of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or other
# materials provided with the distribution.
#
# Neither the name of the copyright holder nor the names of its contributors may be
# used to endorse or promote products derived from this software without specific
# prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
# *********************************************************************************
# Mapper created by LBNL using the measure from openstudio-geb gem
# (https://github.com/LBNL-ETA/Openstudio-GEB-gem)
# *********************************************************************************

require 'urbanopt/reporting'
require 'openstudio/geb'

require_relative 'Baseline'

require 'json'

module URBANopt
  module Scenario
    class PeakHoursThermostatAdjustMapper < BaselineMapper
      # The measure adjusts heating and cooling setpoints by a user-specified number of degrees and a user-specified time period.
      # This is applied throughout the entire building.
      def create_osw(scenario, features, feature_names)
        osw = super(scenario, features, feature_names)
        OpenStudio::Extension.set_measure_argument(osw, 'AdjustThermostatSetpointsByDegreesForPeakHours', '__SKIP__', false)
        # Degrees Fahrenheit to Adjust Cooling Setpoint By
        OpenStudio::Extension.set_measure_argument(osw, 'AdjustThermostatSetpointsByDegreesForPeakHours', 'cooling_adjustment', 2.0)
        # Start Date for Cooling Adjustment Period 1 in MM-DD format
        OpenStudio::Extension.set_measure_argument(osw, 'AdjustThermostatSetpointsByDegreesForPeakHours', 'cooling_start_date1', '06-01')
        # End Date for Cooling Adjustment Period 1 in MM-DD format
        OpenStudio::Extension.set_measure_argument(osw, 'AdjustThermostatSetpointsByDegreesForPeakHours', 'cooling_end_date1', '09-30')
        # Start Time for Cooling Adjustment Period 1. Use 24 hour format HH:MM:SS
        OpenStudio::Extension.set_measure_argument(osw, 'AdjustThermostatSetpointsByDegreesForPeakHours', 'cooling_start_time1', '16:01:00')
        # End Time for Cooling Adjustment Period 1. Use 24 hour format HH:MM:SS
        OpenStudio::Extension.set_measure_argument(osw, 'AdjustThermostatSetpointsByDegreesForPeakHours', 'cooling_end_time1', '20:00:00')

        # Degrees Fahrenheit to Adjust Heating Setpoint By
        OpenStudio::Extension.set_measure_argument(osw, 'AdjustThermostatSetpointsByDegreesForPeakHours', 'heating_adjustment', -2.0)
        # Start Date for Heating Adjustment Period 1 in MM-DD format
        OpenStudio::Extension.set_measure_argument(osw, 'AdjustThermostatSetpointsByDegreesForPeakHours', 'heating_start_date1', '01-01')
        # End Date for Heating Adjustment Period 1 in MM-DD format
        OpenStudio::Extension.set_measure_argument(osw, 'AdjustThermostatSetpointsByDegreesForPeakHours', 'heating_end_date1', '05-31')
        # Start Time for Heating Adjustment for Period 1. Use 24 hour format HH:MM:SS
        OpenStudio::Extension.set_measure_argument(osw, 'AdjustThermostatSetpointsByDegreesForPeakHours', 'heating_start_time1', '18:01:00')
        # End Time for Heating Adjustment for Period 1. Use 24 hour format HH:MM:SS
        OpenStudio::Extension.set_measure_argument(osw, 'AdjustThermostatSetpointsByDegreesForPeakHours', 'heating_end_time1', '22:00:00')

        # Start Date for Heating Adjustment Period 2 in MM-DD format
        OpenStudio::Extension.set_measure_argument(osw, 'AdjustThermostatSetpointsByDegreesForPeakHours', 'heating_start_date2', '10-01')
        # End Date for Heating Adjustment Period 2 in MM-DD format
        OpenStudio::Extension.set_measure_argument(osw, 'AdjustThermostatSetpointsByDegreesForPeakHours', 'heating_end_date2', '12-31')
        # Start Time for Heating Adjustment for Period 2. Use 24 hour format HH:MM:SS
        OpenStudio::Extension.set_measure_argument(osw, 'AdjustThermostatSetpointsByDegreesForPeakHours', 'heating_start_time2', '18:01:00')
        # End Time for Heating Adjustment for Period 2. Use 24 hour format HH:MM:SS
        OpenStudio::Extension.set_measure_argument(osw, 'AdjustThermostatSetpointsByDegreesForPeakHours', 'heating_end_time2', '22:00:00')

        return osw
      end
    end
  end
end
