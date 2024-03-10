import preferences from '@ohos:data.preferences';
import router from '@ohos:router';
import Logger from '@bundle:com.huawei.firststartdemo/entry/ets/common/utils/Logger';
import CommonConstants from '@bundle:com.huawei.firststartdemo/entry/ets/common/constants/CommonConstants';
import CustomDialogComponent from '@bundle:com.huawei.firststartdemo/entry/ets/view/CustomDialogComponent';
import { GlobalContext } from '@bundle:com.huawei.firststartdemo/entry/ets/common/utils/GlobalContext';
class LauncherPage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1) {
        super(parent, __localStorage, elmtId);
        this.context = undefined;
        this.timerId = 0;
        this.isJumpToAdvertising = false;
        this.dialogController = new CustomDialogController({
            builder: () => {
                let jsDialog = new CustomDialogComponent(this, {
                    cancel: () => {
                        this.onCancel();
                    },
                    confirm: () => {
                        this.onConfirm();
                    }
                });
                jsDialog.setController(this.dialogController);
                ViewPU.create(jsDialog);
            },
            alignment: DialogAlignment.Bottom,
            offset: { dx: 0, dy: CommonConstants.DIALOG_CONTROLLER_DY_OFFSET },
            customStyle: true,
            autoCancel: false
        }, this);
        this.setInitiallyProvidedValue(params);
    }
    setInitiallyProvidedValue(params) {
        if (params.context !== undefined) {
            this.context = params.context;
        }
        if (params.timerId !== undefined) {
            this.timerId = params.timerId;
        }
        if (params.isJumpToAdvertising !== undefined) {
            this.isJumpToAdvertising = params.isJumpToAdvertising;
        }
        if (params.dialogController !== undefined) {
            this.dialogController = params.dialogController;
        }
    }
    updateStateVars(params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    onCancel() {
        var _a;
        // Exit the application.
        (_a = this.context) === null || _a === void 0 ? void 0 : _a.terminateSelf();
    }
    onConfirm() {
        // Save privacy agreement status.
        this.saveIsPrivacy();
        this.jumpToAdvertisingPage();
    }
    onPageHide() {
        if (this.isJumpToAdvertising) {
            router.clear();
        }
        // globalThis.isJumpPrivacy = true;
        GlobalContext.getContext().setObject('isJumpPrivacy', true);
        clearTimeout(this.timerId);
    }
    /**
     * Jump to advertising page.
     */
    jumpToAdvertisingPage() {
        this.timerId = setTimeout(() => {
            this.isJumpToAdvertising = true;
            router.pushUrl({
                url: CommonConstants.ADVERTISING_PAGE_URL
            }).catch((error) => {
                Logger.error(CommonConstants.LAUNCHER_PAGE_TAG, 'LauncherPage pushUrl error ' + JSON.stringify(error));
            });
        }, CommonConstants.LAUNCHER_DELAY_TIME);
    }
    saveIsPrivacy() {
        let preferences = this.getDataPreferences(this);
        preferences.then((result) => {
            let privacyPut = result.put(CommonConstants.PREFERENCES_KEY_PRIVACY, false);
            result.flush();
            privacyPut.then(() => {
                Logger.info(CommonConstants.LAUNCHER_PAGE_TAG, 'Put the value of startup Successfully.');
            }).catch((err) => {
                Logger.error(CommonConstants.LAUNCHER_PAGE_TAG, 'Put the value of startup Failed, err: ' + err);
            });
        }).catch((err) => {
            Logger.error(CommonConstants.LAUNCHER_PAGE_TAG, 'Get the preferences Failed, err: ' + err);
        });
    }
    onPageShow() {
        this.context = getContext(this);
        // Get the operation class for saving data.
        this.getDataPreferences(this).then((preferences) => {
            preferences.get(CommonConstants.PREFERENCES_KEY_PRIVACY, true).then((value) => {
                var _a;
                Logger.info(CommonConstants.LAUNCHER_PAGE_TAG, 'onPageShow value: ' + value);
                if (value) {
                    // let isJumpPrivacy: boolean = globalThis.isJumpPrivacy ?? false;
                    let isJumpPrivacy = (_a = GlobalContext.getContext().getObject('isJumpPrivacy')) !== null && _a !== void 0 ? _a : false;
                    if (!isJumpPrivacy) {
                        this.dialogController.open();
                    }
                }
                else {
                    this.jumpToAdvertisingPage();
                }
            });
        });
    }
    /**
     * Get data preferences action.
     */
    getDataPreferences(common) {
        return preferences.getPreferences(getContext(common), CommonConstants.PREFERENCES_FILE_NAME);
    }
    initialRender() {
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Stack.create();
            if (!isInitialRender) {
                Stack.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Image.create({ "id": 16777284, "type": 20000, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Image.width(CommonConstants.FULL_WIDTH);
            Image.height(CommonConstants.FULL_HEIGHT);
            if (!isInitialRender) {
                Image.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Column.create();
            Column.height(CommonConstants.FULL_HEIGHT);
            Column.width(CommonConstants.FULL_WIDTH);
            if (!isInitialRender) {
                Column.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Image.create({ "id": 16777285, "type": 20000, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Image.width({ "id": 16777271, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Image.height({ "id": 16777271, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Image.margin({ top: CommonConstants.LAUNCHER_IMAGE_MARGIN_TOP });
            if (!isInitialRender) {
                Image.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Text.create({ "id": 16777228, "type": 10003, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.width({ "id": 16777270, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.height({ "id": 16777269, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            __Text__healthyLifeTextStyle(FontWeight.Bold, CommonConstants.LAUNCHER_LIFE_TEXT_SPACING, { "id": 16777274, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" }, { "id": 16777242, "type": 10001, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.margin({ top: CommonConstants.LAUNCHER_TEXT_TITLE_MARGIN_TOP });
            if (!isInitialRender) {
                Text.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        Text.pop();
        this.observeComponentCreation((elmtId, isInitialRender) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            Text.create({ "id": 16777227, "type": 10003, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.height(CommonConstants.LAUNCHER_TEXT_INTRODUCE_HEIGHT);
            __Text__healthyLifeTextStyle(FontWeight.Normal, CommonConstants.LAUNCHER_TEXT_INTRODUCE_SPACING, { "id": 16777272, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" }, { "id": 16777241, "type": 10001, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.opacity({ "id": 16777273, "type": 10002, params: [], "bundleName": "com.huawei.firststartdemo", "moduleName": "entry" });
            Text.margin({ top: CommonConstants.LAUNCHER_TEXT_INTRODUCE_MARGIN_TOP });
            if (!isInitialRender) {
                Text.pop();
            }
            ViewStackProcessor.StopGetAccessRecording();
        });
        Text.pop();
        Column.pop();
        Stack.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
// Healthy living text common styles.
function __Text__healthyLifeTextStyle(fontWeight, textAttribute, fontSize, fontColor) {
    Text.fontWeight(fontWeight);
    Text.letterSpacing(textAttribute);
    Text.fontSize(fontSize);
    Text.fontColor(fontColor);
}
ViewStackProcessor.StartGetAccessRecordingFor(ViewStackProcessor.AllocateNewElmetIdForNextComponent());
loadDocument(new LauncherPage(undefined, {}));
ViewStackProcessor.StopGetAccessRecording();
//# sourceMappingURL=LauncherPage.js.map