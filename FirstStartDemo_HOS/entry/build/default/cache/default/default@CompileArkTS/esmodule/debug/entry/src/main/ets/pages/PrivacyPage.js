/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import router from '@ohos:router';
import CommonConstants from '@bundle:com.huawei.firststartdemo/entry/ets/common/constants/CommonConstants';
import { GlobalContext } from '@bundle:com.huawei.firststartdemo/entry/ets/common/utils/GlobalContext';
class PrivacyPage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1) {
        super(parent, __localStorage, elmtId);
        this.setInitiallyProvidedValue(params);
    }
    setInitiallyProvidedValue(params) {
    }
    updateStateVars(params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    initialRender() {
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Column.create();
            Column.justifyContent(FlexAlign.Center);
            Column.height(CommonConstants.FULL_HEIGHT);
            if (!isInitialRender) {
                Column.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Text.create({ "id": 16777233, "type": 10003, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.fontSize({ "id": 16777281, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.textAlign(TextAlign.Center);
            Text.margin({
                top: { "id": 16777280, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" },
                bottom: { "id": 16777279, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" }
            });
            if (!isInitialRender) {
                Text.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        Text.pop();
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Text.create({ "id": 16777232, "type": 10003, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.fontSize({ "id": 16777261, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.margin({
                left: { "id": 16777277, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" },
                right: { "id": 16777278, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" }
            });
            if (!isInitialRender) {
                Text.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        Text.pop();
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Text.create({ "id": 16777231, "type": 10003, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.fontColor({ "id": 16777243, "type": 10001, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.fontSize({ "id": 16777275, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.textAlign(TextAlign.Center);
            Text.fontWeight(FontWeight.Medium);
            Text.onClick(() => {
                // globalThis.isJumpPrivacy = false;
                GlobalContext.getContext().setObject('isJumpPrivacy', false);
                router.back();
            });
            Text.margin({ top: { "id": 16777276, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" } });
            if (!isInitialRender) {
                Text.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        Text.pop();
        Column.pop();
    }
    onBackPress() {
        // globalThis.isJumpPrivacy = false;
        GlobalContext.getContext().setObject('isJumpPrivacy', false);
    }
    rerender() {
        this.updateDirtyElements();
    }
}
ViewStackProcessor.StartGetAccessRecordingFor(ViewStackProcessor.AllocateNewElmetIdForNextComponent());
loadDocument(new PrivacyPage(undefined, {}));
ViewStackProcessor.StopGetAccessRecording();
//# sourceMappingURL=PrivacyPage.js.map