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

import { RNComponentContext, RNViewBase, } from '@rnoh/react-native-openharmony'
import { RNC } from "@rnoh/react-native-openharmony/generated/ts"
import { stringToAlignment, stringToFontStyle } from './conversion'
import Logger from './Logger'

const TAG: string = "[RNOH] RNCPicker"

/**
 * @deprecated Use RNCPicker.NAME instead
 */
export const PICKER_TYPE: string = "RNCPicker"

@Component
export struct RNCPicker {
  public static readonly NAME = RNC.RNCPicker.NAME
  ctx!: RNComponentContext
  tag: number = 0
  @State private descriptorWrapper: RNC.RNCPicker.DescriptorWrapper = {} as RNC.RNCPicker.DescriptorWrapper
  private eventEmitter: RNC.RNCPicker.EventEmitter | undefined = undefined
  private cleanUpCallbacks: (() => void)[] = []
  @State range: string[] = [] // 由label组成，label：Displayed value on the Picker Item
  @State selected: number = 0
  @State value: string | undefined = '' // Actual value on the Picker Item
  private valueMap: Map<string, string> = new Map()

  aboutToAppear() {
    this.eventEmitter = new RNC.RNCPicker.EventEmitter(this.ctx.rnInstance, this.tag)
    this.onDescriptorWrapperChange(this.ctx.descriptorRegistry.findDescriptorWrapperByTag<RNC.RNCPicker.DescriptorWrapper>(this.tag)!)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (_descriptor, newDescriptorWrapper) => {
        this.onDescriptorWrapperChange(newDescriptorWrapper! as RNC.RNCPicker.DescriptorWrapper)
      }
    ))
    this.cleanUpCallbacks.push(new RNC.RNCPicker.CommandReceiver(this.ctx.componentCommandReceiver,
      this.tag).subscribe("setNativeSelectedIndex", (argv) => {
      if (argv) {
        this.selected = argv[0] as number;
      }
    }))
  }

  private onDescriptorWrapperChange(descriptorWrapper: RNC.RNCPicker.DescriptorWrapper) {
    this.descriptorWrapper = descriptorWrapper
    this.range = this.getRange()
    this.valueMap = this.getValueMap()
    this.selected = this.descriptorWrapper.props.selectedIndex ?? 0
    console.info(`[clx] picker: ${JSON.stringify(this.descriptorWrapper.props)}`)
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  getRange(): string[] {
    let items = this.descriptorWrapper.props.items;
    let range: string[] = [];
    let items_num: number = items.length ?? 0
    for (let i = 0; i < items_num; i++) {
      range.push(items[i].label ?? '')
    }
    Logger.debug(TAG, `range: ${range}`)
    return range
  }

  getValueMap(): Map<string, string> {
    let items = this.descriptorWrapper.props.items;
    let valueMap: Map<string, string> = new Map()
    let items_num: number = items.length ? items.length : 0
    for (let i = 0; i < items_num; i++) {
      valueMap.set(items[i].label ?? '', items[i].value ?? '')
    }
    Logger.debug(TAG, `valueMap: ${JSON.stringify(valueMap)}`)
    return valueMap
  }

  getTextStyle(): PickerTextStyle {
    return {
      color: this.descriptorWrapper.props.color ? this.descriptorWrapper.props.color.toRGBAString() : "#ff182431",
      font: {
        size: this.descriptorWrapper.props.fontSize ?? 16,
        weight: this.descriptorWrapper.props.fontWeight ?? FontWeight.Normal,
        style: this.descriptorWrapper.props.fontStyle ? stringToFontStyle(this.descriptorWrapper.props.fontStyle) :
        FontStyle.Normal,
        family: this.descriptorWrapper.props.fontFamily ?? 'Arial'
      },
    };
  }

  getSelectionStyle(): PickerTextStyle {
    return {
      color: this.descriptorWrapper.props.selectionColor ? this.descriptorWrapper.props.selectionColor.toRGBAString() :
        '#ff007dff',
      font: {
        size: this.descriptorWrapper.props.fontSize ?? 16,
        weight: this.descriptorWrapper.props.fontWeight ?? FontWeight.Normal,
        style: this.descriptorWrapper.props.fontStyle ? stringToFontStyle(this.descriptorWrapper.props.fontStyle) :
        FontStyle.Normal,
        family: this.descriptorWrapper.props.fontFamily ?? 'Arial'
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
    this.eventEmitter!.emit("change", {
      newValue: this.value,
      newIndex: this.selected
    })
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      TextPicker({
        range: this.range, // 选择器的数据选择列表
        // selected: this.selected, // 设置默认选中项在数组中的索引值
        value: this.value, // 设置默认选中项的值，优先级低于selected
      })// .defaultPickerItemHeight() // 设置Picker各选择项的高度
        .disappearTextStyle(this.getTextStyle())// 设置所有选项中最上和最下两个选项的文本颜色、字号、字体粗细
        .textStyle(this.getTextStyle())// 设置所有选项中除了最上、最下及选中项以外的文本颜色、字号、字体粗细
        .selectedTextStyle(this.getSelectionStyle())// 设置选中项的文本颜色、字号、字体粗细
        .selectedIndex(this.selected)// 设置默认选中项在数组中的索引值，优先级高于options中的选中值
        .canLoop(false)// 设置是否可循环滚动
        .onChange((value: string | string[], index: number | number[]) => this._onChange(value, index))
        .width("100%")
        .height("100%")
    }
  }
}