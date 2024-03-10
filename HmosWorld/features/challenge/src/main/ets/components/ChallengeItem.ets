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
import common from '@ohos.app.ability.common';
import { BreakpointType, BreakpointTypeEnum } from '@ohos/utils';
import { ChallengeConstants as Const } from '../constants/ChallengeConstants';

@Component
export default struct ChallengeItem {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;

  build() {
    Column() {
      Column() {
        Column() {
          Text($r('app.string.code_lab_challenge'))
            .fontWeight(FontWeight.Medium)
            .fontSize(new BreakpointType<Length>({
              sm: $r('app.float.challenge_title_size_sm'),
              md: $r('app.float.navigation_title_size'),
              lg: $r('app.float.challenge_title_size_lg')
            }).getValue(this.currentBreakpoint))
          Text($r('app.string.challenge_desc'))
            .margin({ top: $r('app.float.normal_margin') })
            .fontColor($r('app.color.train_interval'))
            .fontSize(new BreakpointType<Length>({
              sm: $r('app.float.smaller_font_size'),
              md: $r('app.float.challenge_title_size_sm'),
              lg: $r('app.float.challenge_desc_size_lg')
            }).getValue(this.currentBreakpoint))
        }
        .alignItems(HorizontalAlign.Start)

        Button($r('app.string.go_now'))
          .height(new BreakpointType<Length>({
            sm: $r('app.float.sm_btn_height'),
            md: $r('app.float.md_btn_height'),
            lg: $r('app.float.lg_btn_height')
          }).getValue(this.currentBreakpoint))
          .fontSize(new BreakpointType<Length>({
            sm: $r('app.float.small_font_size'),
            md: $r('app.float.challenge_desc_size_lg'),
            lg: $r('app.float.navigation_title_size')
          }).getValue(this.currentBreakpoint))
          .onClick(() => {
            let bundleName = (getContext(this) as common.UIAbilityContext).applicationInfo.name;
            router.pushUrl({
              url: `@bundle:${bundleName}/challenge/ets/pages/ChallengeDetailPage`
            });
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Start)
      .borderRadius($r('app.float.introduction_image_border_radius'))
      .width(new BreakpointType<Length>({
        sm: Const.PERCENT_86,
        md: Const.PERCENT_70,
        lg: Const.PERCENT_47
      }).getValue(this.currentBreakpoint))
      .backgroundImage($r('app.media.ic_challenge_bg'))
      .backgroundImageSize(ImageSize.Cover)
      .aspectRatio(2.5)
      .padding({
        left: $r('app.float.xxl_padding_margin'),
        top: $r('app.float.normal_padding'),
        bottom: $r('app.float.normal_padding')
      })
    }
    .padding({
      bottom: $r('app.float.xxl_padding_margin')
    })
  }
}