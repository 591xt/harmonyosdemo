/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { ApplicationFileTab } from '../view/ApplicationFileTab';
import { publicFilesTab } from '../view/PublicFilesTab';

@Entry
@Component
struct HomePage {
  build() {
    Column() {
      Column() {
        Text($r('app.string.title'))
          .width($r('app.float.default_312'))
          .height($r('app.float.default_41'))
          .textAlign(TextAlign.Start)
          .fontSize($r('app.float.default_30'))
          .fontFamily('HarmonyHeiTi-Bold')
          .fontColor($r('app.color.text_color'))
          .lineHeight($r('app.float.default_41'))
          .fontWeight(700)
          .margin({
            top: $r('app.float.default_7'),
            bottom: $r('app.float.default_8'),
            left: $r('app.float.default_24'),
            right: $r('app.float.default_24')
          })
      }
      .width($r('app.float.default_360'))
      .height($r('app.float.default_56'))

      Tabs() {
        TabContent() {
          ApplicationFileTab()
        }
        .tabBar(new SubTabBarStyle($r('app.string.bar1'))
          .indicator({ marginTop: $r('app.float.default_8') })
          .labelStyle({ font: { size: $r('app.float.default_16') } })
        )

        TabContent() {
          Scroll() {
            publicFilesTab()
          }
          .height($r('app.float.default_680'))
        }
        .height('100%')
        .tabBar(new SubTabBarStyle($r('app.string.bar2'))
          .indicator({marginTop : $r('app.float.default_8')})
          .labelStyle({font : {size : $r('app.float.default_16')}})
        )
      }
      .barWidth($r('app.float.default_200'))
      .barHeight($r('app.float.default_56'))
      .width('100%')
    }
    .backgroundColor($r('app.color.picture_background'))
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }
}