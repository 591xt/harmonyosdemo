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

import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import picker from '@ohos.file.picker';
import image from '@ohos.multimedia.image';
import router from '@ohos.router'
import { BreakpointSystem, BreakpointType, BreakpointTypeEnum, CommonConstants, Logger } from '@ohos/utils';
import Constants from '../constants/Constants';

/**
 * picker init;
 */
const photoSelectOptions = new picker.PhotoSelectOptions();
photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
photoSelectOptions.maxSelectNumber = 1;
let uris: Array<string> = [];
const photoViewPicker = new picker.PhotoViewPicker();
let pixel: PixelMap;
let breakpointType: BreakpointType<string> = new BreakpointType<string>({
  sm: Constants.IMAGE_RATIO_PHONR,
  md: Constants.IMAGE_RATIO_FOLD,
  lg: Constants.IMAGE_RATIO_PAD
})
let breakpointImage: BreakpointType<Resource> = new BreakpointType<Resource>({
  sm: $r('app.float.safe_logo_margin'),
  md: $r('app.float.fold_image_top'),
  lg: $r('app.float.pad_image_top')
})


@Entry
@Component
struct PhotoPage {
  @State
  showTag: number = 0;
  @StorageLink('profilePath')
  profilePath: string = '';
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();

  onPageShow() {
    if (this.profilePath != '') {
      let imageSource: image.ImageSource = image.createImageSource(this.profilePath);
      imageSource.createPixelMap((err, pixelmap) => {
        pixel = pixelmap;
        this.showTag++;
      })
    }
  }

  aboutToAppear() {
    this.breakpointSystem.register();
  }

  aboutToDisappear() {
    this.breakpointSystem.unregister();
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_public_cancel'))
          .height($r('app.float.normal_icon_size'))
          .width($r('app.float.normal_icon_size'))
          .fillColor(Color.White)
          .onClick(() => {
            router.back();
          })
      }
      .padding({ top: $r('app.float.md_padding_margin') })
      .justifyContent(FlexAlign.Start)
      .width(CommonConstants.FULL_PERCENT)
      .margin({
        top: AppStorage.get('statusBarHeight') as number,
        left: $r('app.float.xxl_padding_margin'),
        bottom: breakpointImage.getValue(this.currentBreakpoint)
      })

      Row() {
        Image(this.showTag > 0 ? pixel : $r('app.media.developer_two'))
          .visibility(!this.showTag ? Visibility.None : Visibility.Visible)
          .aspectRatio(1)
        Image($r('app.media.developer_two'))
          .visibility(this.showTag ? Visibility.None : Visibility.Visible)
          .aspectRatio(1)
      }
      .height(breakpointType.getValue(this.currentBreakpoint))

      Row() {
        Button($r('app.string.editPhoto'))
          .backgroundColor($r('app.color.back_color'))
          .fontColor($r('app.color.font_color'))
          .type(ButtonType.Capsule)
          .size({
            width: $r('app.float.button_change_width'),
            height: $r('app.float.button_height')
          })
          .margin({ top: $r('app.float.tab_big_img_width') })
          .onClick(() => {
            photoViewPicker.select(photoSelectOptions).then((photoSelectResult: picker.PhotoSelectResult) => {
              uris = photoSelectResult.photoUris;
              const bundleName = (getContext(this) as common.UIAbilityContext).applicationInfo.name;
              router.pushUrl({ url: `@bundle:${bundleName}/mine/ets/pages/ConfirmPage`, params: {
                uri: uris[0]
              } }, router.RouterMode.Single);
            }).catch((err: BusinessError) => {
              Logger.error(`Invoke photoViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
            })
          })
      }
    }
    .backgroundColor(Color.Black)
    .height(CommonConstants.FULL_PERCENT)
  }
}