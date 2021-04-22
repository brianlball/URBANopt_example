# *********************************************************************************
# URBANopt™, Copyright (c) 2019-2021, Alliance for Sustainable Energy, LLC, and other
# contributors. All rights reserved.

# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:

# Redistributions of source code must retain the above copyright notice, this list
# of conditions and the following disclaimer.

# Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or other
# materials provided with the distribution.

# Neither the name of the copyright holder nor the names of its contributors may be
# used to endorse or promote products derived from this software without specific
# prior written permission.

# Redistribution of this software, without modification, must refer to the software
# by the same designation. Redistribution of a modified version of this software
# (i) may not refer to the modified version by the same designation, or by any
# confusingly similar designation, and (ii) must refer to the underlying software
# originally provided by Alliance as “URBANopt”. Except to comply with the foregoing,
# the term “URBANopt”, or any confusingly similar designation may not be used to
# refer to any modified version of this software or any modified version of the
# underlying software originally provided by Alliance without the prior written
# consent of Alliance.

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

require 'urbanopt/reporting'
require 'openstudio/common_measures'
require 'openstudio/model_articulation'
require 'openstudio/load_flexibility_measures'

require_relative 'HighEfficiency'

require 'json'

module URBANopt
  module Scenario
    class ThermalStorageMapper < HighEfficiencyMapper
      def create_osw(scenario, features, feature_names)
        osw = super(scenario, features, feature_names)

        # Add ice to applicable TES object building and set applicable charge and discharge times

        if feature_names[0].to_s == 'Mixed_use 1'
          OpenStudio::Extension.set_measure_argument(osw, 'add_central_ice_storage', '__SKIP__', false)
          OpenStudio::Extension.set_measure_argument(osw, 'add_central_ice_storage', 'storage_capacity', 6000)
          OpenStudio::Extension.set_measure_argument(osw, 'add_central_ice_storage', 'chiller_resize_factor', 1.0)
          OpenStudio::Extension.set_measure_argument(osw, 'add_central_ice_storage', 'chiller_limit', 1.0)
          OpenStudio::Extension.set_measure_argument(osw, 'add_central_ice_storage', 'loop_sp', 44.0)
          OpenStudio::Extension.set_measure_argument(osw, 'add_central_ice_storage', 'inter_sp', 47.0)
          OpenStudio::Extension.set_measure_argument(osw, 'add_central_ice_storage', 'chg_sp', 25.0)
          OpenStudio::Extension.set_measure_argument(osw, 'add_central_ice_storage', 'dr_dur', 3.0)
        end

        if feature_names[0].to_s == 'Restaurant 1'
          OpenStudio::Extension.set_measure_argument(osw, 'add_packaged_ice_storage', '__SKIP__', false)
          OpenStudio::Extension.set_measure_argument(osw, 'add_packaged_ice_storage', 'size_mult', 1.0)
          OpenStudio::Extension.set_measure_argument(osw, 'add_packaged_ice_storage', 'charge_start', 22)
          OpenStudio::Extension.set_measure_argument(osw, 'add_packaged_ice_storage', 'charge_end', 7)
          OpenStudio::Extension.set_measure_argument(osw, 'add_packaged_ice_storage', 'discharge_start', 12)
          OpenStudio::Extension.set_measure_argument(osw, 'add_packaged_ice_storage', 'discharge_end', 18)
        end

        return osw
      end
    end
  end
end
