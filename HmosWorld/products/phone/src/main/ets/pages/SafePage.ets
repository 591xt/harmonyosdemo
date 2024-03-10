import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { SplashConstants } from '../Constants/SplashConstants';
import { BreakpointSystem, BreakpointType, BreakpointTypeEnum, ColumnEnum, CommonConstants,
  OffsetEnum,
  SpanEnum } from '@ohos/utils';

@Entry
@Component
struct SafePage {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();

  aboutToAppear() {
    this.breakpointSystem.register();
  }

  aboutToDisappear() {
    this.breakpointSystem.unregister();
  }

  build() {
    GridRow({
      columns: {
        sm: ColumnEnum.SM,
        md: ColumnEnum.MD,
        lg: ColumnEnum.LG
      },
      gutter: {
        x: { sm: $r('app.float.grid_gutter'), md: $r('app.float.grid_gutter'), lg: $r('app.float.grid_gutter') }
      },
    }) {
      GridCol({
        span: {
          sm: SpanEnum.SM,
          md: SpanEnum.MD,
          lg: SpanEnum.LG
        },
        offset: {
          sm: OffsetEnum.SM,
          md: OffsetEnum.MD,
          lg: OffsetEnum.LG
        }
      }) {
        Column() {
          Image($r('app.media.app_icon'))
            .width(new BreakpointType<Resource>({
              sm: $r('app.float.safe_logo_sm_md'),
              md: $r('app.float.safe_logo_sm_md'),
              lg: $r('app.float.safe_logo_lg'),
            }).getValue(this.currentBreakpoint))
            .aspectRatio(1)
            .margin({ top: $r('app.float.safe_logo_margin') })
          Text($r('app.string.welcome_to_use'))
            .fontSize($r('app.float.normal_text_size'))
            .fontColor($r('app.color.grey_text_color'))
            .lineHeight($r('app.float.welcome_line_height'))
            .margin({ top: $r('app.float.xxl_padding_margin') })
          Text($r('app.string.EntryAbility_label'))
            .fontSize($r('app.float.safe_title_font_size'))
            .fontColor(Color.Black)
            .lineHeight($r('app.float.safe_title_line_height'))
            .fontWeight(FontWeight.Medium)
          Text($r('app.string.service_desc'))
            .fontSize($r('app.float.normal_text_size'))
            .fontColor($r('app.color.grey_text_color'))
            .lineHeight($r('app.float.welcome_line_height'))
            .margin({ top: $r('app.float.ss_padding_margin') })

          Blank()

          Image($r('app.media.ic_safe'))
            .height($r('app.float.safe_icon_size'))
            .height($r('app.float.safe_icon_size'))
            .margin({ bottom: $r('app.float.safe_icon_margin_bottom') })

          Text() {
            Span($r('app.string.safe_desc1_str1'))
              .fontSize($r('app.float.little_text_size'))
              .fontColor($r('app.color.grey_text_color'))
              .lineHeight($r('app.float.safe_desc_line_height'))
            Span($r('app.string.safe_desc1_str2'))
              .fontSize($r('app.float.little_text_size'))
              .fontColor($r('app.color.permission_text_color'))
              .fontWeight(FontWeight.Medium)
              .lineHeight($r('app.float.safe_desc_line_height'))
            Span($r('app.string.safe_desc1_str3'))
              .fontSize($r('app.float.little_text_size'))
              .lineHeight($r('app.float.safe_desc_line_height'))
            Span($r('app.string.safe_desc1_str4'))
              .fontColor($r('app.color.permission_text_color'))
              .fontSize($r('app.float.little_text_size'))
              .fontWeight(FontWeight.Medium)
              .lineHeight($r('app.float.safe_desc_line_height'))
            Span($r('app.string.safe_desc1_str5'))
              .fontSize($r('app.float.little_text_size'))
              .fontColor($r('app.color.grey_text_color'))
              .lineHeight($r('app.float.safe_desc_line_height'))
            Span($r('app.string.safe_desc1_str6'))
              .fontSize($r('app.float.little_text_size'))
              .fontColor($r('app.color.theme_blue_color'))
              .fontWeight(FontWeight.Medium)
              .lineHeight($r('app.float.safe_desc_line_height'))
              .onClick(() => {
                router.pushUrl({ url: 'pages/PrivacyPage' })
              })
            Span($r('app.string.safe_desc1_str7'))
              .fontSize($r('app.float.little_text_size'))
              .fontColor($r('app.color.grey_text_color'))
              .lineHeight($r('app.float.safe_desc_line_height'))
          }
          .width(CommonConstants.FULL_PERCENT)

          Text($r('app.string.safe_desc2'))
            .fontSize($r('app.float.little_text_size'))
            .fontColor($r('app.color.grey_text_color'))
            .lineHeight($r('app.float.safe_desc_line_height'))
            .width(CommonConstants.FULL_PERCENT)
            .margin({ top: $r('app.float.ss_padding_margin') })

          Row({ space: CommonConstants.SPACE_12 }) {
            Button($r('app.string.button_cancel'))
              .backgroundColor($r('app.color.safe_cancel_button_bg'))
              .fontColor($r('app.color.theme_blue_color'))
              .layoutWeight(1)
              .onClick(() => {
                let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
                context.terminateSelf();
              })
            Button($r('app.string.button_agree'))
              .backgroundColor($r('app.color.theme_blue_color'))
              .fontColor(Color.White)
              .layoutWeight(1)
              .onClick(() => {
                router.back({ url: 'pages/SplashPage', params: { isAgreedPrivacy: true } })
              })
          }
          .width(CommonConstants.FULL_PERCENT)
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ top: $r('app.float.xxl_padding_margin'), bottom: $r('app.float.safe_button_margin_bottom') })
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)
        .backgroundColor($r('app.color.common_background_color'))
      }
    }
    .backgroundColor($r('app.color.common_background_color'))
    .padding({ left: $r('app.float.xxl_padding_margin'), right: $r('app.float.xxl_padding_margin') })
  }
}