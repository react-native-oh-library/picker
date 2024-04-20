/**
 * MIT License
 *
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import {
  Descriptor,
  RNOHContext,
  ViewBaseProps,
  RNViewBase,
  ColorSegments,
  convertColorSegmentsToString,
} from '@rnoh/react-native-openharmony'

import { stringToAlignment, stringToFontStyle } from './conversion'
import Logger from './Logger'

const TAG:string = "[RNOH] RNCPicker"
export const PICKER_TYPE:string = "RNCPicker"
interface PickerItems {
  label : string,
  value : string,
  textColor : ColorSegments
  testID: string
}

export interface PickerProps extends ViewBaseProps {
  items : PickerItems[],
  selectedIndex ?: number,
  selectionColor ?: ColorSegments, // 未实现，选中项的背景颜色。现在作为选中项的字体颜色。
  color?: ColorSegments,
  textAlign?: string, // 未实现， 选项文本居中
  numberOfLines?: number, // 未实现，文本行数
  fontSize?: number,
  fontWeight?: string,
  fontStyle?: string,
  fontFamily?: string,
  themeVariant?: string // 未实现，明暗主题变换
  testID?: string
}
export type RNCPickerDescriptor = Descriptor<"RNCPicker", PickerProps>

@Component
export struct RNCPicker {
  ctx!: RNOHContext
  tag: number = 0
  @State descriptor: RNCPickerDescriptor = {} as RNCPickerDescriptor
  private unregisterDescriptorChangesListener?: () => void = undefined
  private cleanupCommandCallback?: () => void = undefined
  @State range: string[] = []  // 由label组成，label：Displayed value on the Picker Item
  @State selected: number = 0
  @State value: string | undefined = ''  // Actual value on the Picker Item
  private valueMap: Map<string, string> = new Map()

  aboutToAppear() { this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNCPickerDescriptor>(this.tag)
    this.unregisterDescriptorChangesListener = this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNCPickerDescriptor)
      }
    )
    this.cleanupCommandCallback = this.ctx.componentCommandReceiver.registerCommandCallback(
      this.tag,
      (command, args:(number|null)[]) => {
        if (command === 'setNativeSelectedIndex') {
          Logger.info(TAG, `CommandCallback, setNativeSelectedIndex: ${args[0]}`)
          if (args) this.selected = args[0] as number;
        }
      }
    )
    Logger.info(TAG, `RNCPickerDescriptor, ${JSON.stringify(this.descriptor.props)}`)
    this.range = this.getRange(this.descriptor.props.items)
    this.valueMap = this.getValueMap(this.descriptor.props.items)
    this.selected = this.descriptor.props.selectedIndex ? this.descriptor.props.selectedIndex : 0

  }
  aboutToDisappear() {
    this.unregisterDescriptorChangesListener?.()
    this.cleanupCommandCallback?.()
  }

  getRange(items: PickerItems[]): string[] {
    let range: string[] = [];
    let items_num: number = items.length ? items.length : 0
    for (let i = 0; i < items_num; i++) {
      range.push(items[i].label)
    }
    Logger.debug(TAG, `range: ${range}`)
    return range
  }

  getValueMap(items: PickerItems[]): Map<string, string> {
    let valueMap: Map<string, string> = new Map()
    let items_num: number = items.length ? items.length : 0
    for (let i = 0; i < items_num; i++) {
      valueMap.set(items[i].label, items[i].value)
    }
    Logger.debug(TAG, `valueMap: ${JSON.stringify(valueMap)}`)
    return valueMap
  }

  getTextStyle(): PickerTextStyle {
    return {
      color: this.descriptor.props.color ? convertColorSegmentsToString(this.descriptor.props.color) : "#ff182431",
      font: {
        size: this.descriptor.props.fontSize ? this.descriptor.props.fontSize : 16,
        weight: this.descriptor.props.fontWeight ? this.descriptor.props.fontSize : FontWeight.Normal,
        style: this.descriptor.props.fontStyle ? stringToFontStyle(this.descriptor.props.fontStyle) : FontStyle.Normal,
        family: this.descriptor.props.fontFamily ? this.descriptor.props.fontFamily : 'Arial'
      },
    };
  }

  getSelectionStyle(): PickerTextStyle {
    return {
      color: this.descriptor.props.selectionColor ? convertColorSegmentsToString(this.descriptor.props.selectionColor) : '#ff007dff',
      font: {
        size: this.descriptor.props.fontSize ? this.descriptor.props.fontSize : 16,
        weight: this.descriptor.props.fontWeight ? this.descriptor.props.fontSize : FontWeight.Normal,
        style: this.descriptor.props.fontStyle ? stringToFontStyle(this.descriptor.props.fontStyle) : FontStyle.Normal,
        family: this.descriptor.props.fontFamily ? this.descriptor.props.fontFamily : 'Arial'
      },
    };
  }

  _onChange(value: string | string[], index: number | number[]): void {
    if (typeof value === 'string') {
      this.value = this.valueMap.get(value)
    }
    if (typeof index === 'number') {
      this.selected = index
    }
    this.ctx.rnInstance.emitComponentEvent(
      this.descriptor.tag,
      PICKER_TYPE,
      {
        type: "change",
        newValue: this.value,
        newIndex: this.selected
      }
    )
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      TextPicker({ range: this.range, // 选择器的数据选择列表
        // selected: this.selected, // 设置默认选中项在数组中的索引值
        value: this.value, // 设置默认选中项的值，优先级低于selected
      })
        // .defaultPickerItemHeight() // 设置Picker各选择项的高度
        .disappearTextStyle(this.getTextStyle()) // 设置所有选项中最上和最下两个选项的文本颜色、字号、字体粗细
        .textStyle(this.getTextStyle()) // 设置所有选项中除了最上、最下及选中项以外的文本颜色、字号、字体粗细
        .selectedTextStyle(this.getSelectionStyle()) // 设置选中项的文本颜色、字号、字体粗细
        .selectedIndex(this.selected) // 设置默认选中项在数组中的索引值，优先级高于options中的选中值
        .canLoop(false) // 设置是否可循环滚动
        .onChange((value: string | string[], index: number | number[]) => this._onChange(value, index))
        .width("100%")
        .height("100%")
    }
  }
}