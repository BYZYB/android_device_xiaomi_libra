/*
 * Copyright (C) 2020 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "KeyDisabler.h"
#include <android-base/file.h>
#include <android-base/logging.h>
#include <android-base/strings.h>

using ::android::base::ReadFileToString;
using ::android::base::Trim;
using ::android::base::WriteStringToFile;

namespace vendor
{
    namespace lineage
    {
        namespace touch
        {
            namespace V1_0
            {
                namespace implementation
                {
                    constexpr const char kControlPath[] = "/proc/touchscreen/nav_button_enable";

                    KeyDisabler::KeyDisabler()
                    {
                        has_key_disabler = !access(kControlPath, F_OK);
                    }

                    // Methods from ::vendor::lineage::touch::V1_0::IKeyDisabler follow.
                    Return<bool> KeyDisabler::isEnabled()
                    {
                        std::string buf;

                        if (!has_key_disabler)
                        {
                            return false;
                        }

                        if (!ReadFileToString(kControlPath, &buf, true))
                        {
                            LOG(ERROR) << "Failed to read from " << kControlPath;
                            return false;
                        }

                        return Trim(buf) == "0";
                    }

                    Return<bool> KeyDisabler::setEnabled(bool enabled)
                    {
                        if (!has_key_disabler)
                        {
                            return false;
                        }

                        if (!WriteStringToFile(enabled ? "0" : "1", kControlPath, true))
                        {
                            LOG(ERROR) << "Failed to write to " << kControlPath;
                            return false;
                        }

                        return true;
                    }

                } // namespace implementation
            }     // namespace V1_0
        }         // namespace touch
    }             // namespace lineage
} // namespace vendor
