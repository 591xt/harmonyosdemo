import common from '@ohos.app.ability.common';
import window from '@ohos.window';
import Logger from './Logger';

const TAG: string = '[WindowUtil]';

export class WindowUtil {
  public static updateStatusBarColor(context: common.BaseContext, isDark: boolean) {
    window.getLastWindow(context).then((windowClass: window.Window) => {
      try {
        windowClass.setWindowSystemBarProperties({ statusBarContentColor: isDark ? '#FFFFFF' : '#000000' }, (err) => {
          if (err.code) {
            Logger.error(TAG, 'Failed to set the system bar properties. Cause: ' + JSON.stringify(err));
            return;
          }
          Logger.info(TAG, 'Succeeded in setting the system bar properties.');
        });
      } catch (exception) {
        Logger.error(TAG, 'Failed to set the system bar properties. Cause: ' + JSON.stringify(exception));
      }
    });
  }
}