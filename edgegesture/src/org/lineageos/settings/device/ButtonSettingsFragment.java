/*
 * Copyright (C) 2019 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.lineageos.settings.device;

import android.app.ActionBar;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import androidx.preference.PreferenceFragment;
import androidx.preference.SwitchPreference;
import androidx.preference.ListPreference;
import androidx.preference.Preference;
import androidx.preference.Preference.OnPreferenceChangeListener;
import androidx.preference.PreferenceCategory;
import androidx.preference.PreferenceManager;
import android.text.TextUtils;
import android.view.MenuItem;

import org.lineageos.internal.util.FileUtils;
import org.lineageos.internal.util.PackageManagerUtils;

public class ButtonSettingsFragment extends PreferenceFragment implements OnPreferenceChangeListener {

    private Context mContext;

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        addPreferencesFromResource(R.xml.button_panel);
        final ActionBar actionBar = getActivity().getActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        mContext = context;
    }

    @Override
    public boolean onPreferenceChange(Preference pref, Object newValue) {
        SwitchPreferenceBackend backend = Constants.sBackendsMap.get(pref.getKey());
        Boolean value = (Boolean) newValue;

        backend.setValue(value);

        SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(mContext);
        SharedPreferences.Editor editor = preferences.edit();
        editor.putBoolean("edge_gesture", value);
        editor.commit();

        return true;
    }

    @Override
    public void addPreferencesFromResource(int preferencesResId) {
        super.addPreferencesFromResource(preferencesResId);

        // Initialize node preferences
        for (String key : Constants.sBackendsMap.keySet()) {
            SwitchPreference pref = (SwitchPreference) findPreference(key);
            if (pref == null) {
                continue;
            }

            pref.setOnPreferenceChangeListener(this);

            SwitchPreferenceBackend backend = Constants.sBackendsMap.get(key);
            if (!backend.isValid()) {
                pref.setEnabled(false);
            } else {
                pref.setChecked(backend.getValue());
            }
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            getActivity().onBackPressed();
            return true;
        }
        return false;
    }
}
