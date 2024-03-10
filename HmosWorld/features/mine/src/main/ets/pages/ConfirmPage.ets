/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import { BreakpointSystem, BreakpointType, BreakpointTypeEnum, CommonConstants } from '@ohos/utils';
import Constants from '../constants/Constants';

let params: Record<string, Object> = router.getParams() as Record<string, Object>;
let uri: string = params['uri'].toString();
let context = getContext(this) as common.ApplicationContext;
let filesDir = context.cacheDir;
let imageWidth: BreakpointType<string> = new BreakpointType<string>({
  sm: CommonConstants.FULL_PERCENT,
  md: Constants.CLIP_RATIO_FOLD,
  lg: Constants.CLIP_RATIO_PAD
})
let halfImagetop: BreakpointType<Resource> = new BreakpointType<Resource>({
  sm: $r('app.float.safe_logo_sm_md'),
  md: $r('app.float.xxl_padding_margin'),
  lg: $r('app.float.account_padding_top')
})

@Entry
@Component
struct ConfirmPage {
  @StorageLink('profilePath')
  profilePath: string = '';
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();

  aboutToAppear() {
    this.breakpointSystem.register();
  }

  aboutToDisappear() {
    this.breakpointSystem.unregister();
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .height($r('app.float.normal_icon_size'))
          .width($r('app.float.normal_icon_size'))
          .fillColor(Color.Black)
          .onClick(() => {
            router.back();
          })

        Image($r('app.media.ic_public_ok'))
          .height($r('app.float.normal_icon_size'))
          .width($r('app.float.normal_icon_size'))
          .fillColor(Color.Black)
          .onClick(() => {
            let srcFile = fs.openSync(uri, fs.OpenMode.READ_ONLY);
            let destFile = fs.openSync(filesDir + '/profile.jpg', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
            fs.copyFileSync(srcFile.fd, destFile.fd);
            fs.closeSync(srcFile);
            fs.closeSync(destFile);
            this.profilePath = filesDir + '/profile.jpg';
            router.back();
          })
      }
      .padding({
        right: $r('app.float.xxl_padding_margin'),
        left: $r('app.float.xxl_padding_margin'),
        top: $r('app.float.xxl_padding_margin')
      })
      .justifyContent(FlexAlign.SpaceBetween)
      .width(CommonConstants.FULL_PERCENT)
      .margin({ bottom: halfImagetop.getValue(this.currentBreakpoint), top: $r('app.float.xxl_padding_margin') })

      Stack() {
        Image(uri)
          .mask(new Rect({
            width: CommonConstants.FULL_PERCENT,
            height: CommonConstants.FULL_PERCENT
          }).fill(Color.Gray))
          .aspectRatio(Constants.CLIP_RATIO_PHONR)
        Image(uri)
          .aspectRatio(Constants.CLIP_RATIO_PHONR)
          .clip(new Circle({ height: Constants.CLIP_RATIO, width: CommonConstants.FULL_PERCENT })
            .position({
              y: Constants.CIRCLE_RATIO_Y
            })
          )
      }
      .width(imageWidth.getValue(this.currentBreakpoint))
    }
    .backgroundColor(Color.White)
    .height(CommonConstants.FULL_PERCENT)
    .justifyContent(FlexAlign.Start)
  }
}