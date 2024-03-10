/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
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

package com.huawei.jsdistributedraw;

import ohos.aafwk.content.Intent;
import ohos.ace.ability.AceAbility;

/**
 * MainAbility
 *
 * @since 2021-11-10
 */
public class MainAbility extends AceAbility {
    @Override
    public void onStart(Intent intent) {
        String[] permissions = {"ohos.permission.DISTRIBUTED_DATASYNC"};
        requestPermissionsFromUser(permissions, 0);
        super.onStart(intent);
    }

    @Override
    public void onStop() {
        super.onStop();
    }
}
