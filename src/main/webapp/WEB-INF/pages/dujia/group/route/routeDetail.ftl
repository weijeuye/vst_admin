    <div class="JS_day">

            <div class="gi-inner-dl clearfix">
                <#-- 存放行程明细的隐藏域DIV -->
                <div class="lineRouteDetailHiddenDiv" style="display:none;">
                    <input type="hidden" name="prodLineRouteDetailList[${r_index}].detailId" value="${r.detailId}">
                    <input type="hidden" name="prodLineRouteDetailList[${r_index}].nDay" value="${(r.nDay??)?string(r.nDay, r_index+1)}" class="JS_day_num_input">
                    <#-- 通过js中方法buildRouteDetailTitle()将多个地点拼接为title -->
                    <input type="hidden" name="prodLineRouteDetailList[${r_index}].title" value="${r.title!''}" class="JS_title" >
                </div>

                <div class="gi-inner-dt">第 <em class="JS_day_num">${r_index + 1}</em> 天　</div>
                <div class="gi-inner-dd gi-destinations JS_destinations">
                    <#if r.title??>
                    <#assign titles = r.title?split("—") />
                    <#assign titles_length = titles?size />
                    <#list titles as title>
                        <div class="gi-destination JS_destination">
                            <input type="text" value="${title!'输入地点'}" class="input-text gi-w100 placeholder notDashTest" maxlength="20" data-placeholder="输入地点"
                                   data-validate="true" required />
                            <b <#if title_index = titles_length - 1>style="display: none;"</#if>>-</b>
                            <#if title_index gt 0>
                            <a href="javascript:" class="gi-del JS_del_destination">删除</a>
                            </#if>
                        </div>
                    </#list>
                    </#if>
                    <div class="gi-destination gi-destination-add JS_destination_add">
                        <a href="javascript:" class="JS_add_destination">添加目的地</a>
                    </div>
                </div>
            </div>

            <div class="gi-inner-dl clearfix">
                <div class="gi-inner-dt">行程描述：</div>

                <div class="gi-inner-dd"><textarea class="gi-w500 gi-h150" cols="30" rows="10" name="prodLineRouteDetailList[${r_index}].content" maxlength="2000">${r.content!''}</textarea></div>
            </div>

            <div class="gi-inner-dl clearfix">
                <div class="gi-inner-dt">住宿：</div>
                <div class="gi-inner-dd JS_radio_box">
                    <p>
                        <span class="JS_radio_switch_box">
                            <label>
                                 <#-- 值360是对应老页面中的选择酒店列表下拉信息中的 其他 项（新页面中已将其去掉，行程明细表中无直接存储 含、不含住宿 的字段，间接通过stayType存储） -->
                                <#assign contain_stay = (r.stayType?? && r.stayType != null && r.stayType != "")?string('Y','N') />
                                <input type="radio" name="prodLineRouteDetailList[${r_index}].stayType" value="360" <#if contain_stay == 'Y'>checked="checked"</#if> class="JS_radio_switch" />含住宿
                            </label>

                            <input type="text" name="prodLineRouteDetailList[${r_index}].stayDesc" value="${r.stayDesc!'输入参考酒店'}" <#if contain_stay == 'N'>disabled="disabled"</#if>
                                   class="input-text gi-w400 JS_radio_disabled" data-placeholder="输入参考酒店"
                                   required="required" data-validate="true" maxlength="200" />
                        </span>
                    </p>

                    <p>
                        <label>
                            <input type="radio" name="prodLineRouteDetailList[${r_index}].stayType" value="" <#if contain_stay == 'N'>checked="checked"</#if> class="JS_radio_switch" />不含住宿
                        </label>
                    </p>
                </div>
            </div>

            <div class="gi-inner-dl clearfix">
                <div class="gi-inner-dt">用餐：</div>
                <div class="gi-inner-dd JS_dinner_box">
                    <span class="JS_checkbox_switch_box JS_dinner_checkbox_box gi-mr35">
                        <label>
                            <input type="checkbox" name="prodLineRouteDetailList[${r_index}].breakfastFlag" value="Y" class="JS_checkbox_switch JS_dinner_checkbox" <#if r.breakfastFlag == 'Y'>checked="checked"</#if> />早餐
                        </label>
                        <input type="text" name="prodLineRouteDetailList[${r_index}].breakfastDesc" value="${r.breakfastDesc!'敬请自理'}" class="input-text gi-w80 JS_checkbox_disabled JS_dinner_input"
                            <#if r.breakfastFlag != 'Y'>disabled="disabled"</#if> data-validate="true" maxlength="100" required/>
                    </span>

                    <span class="JS_checkbox_switch_box JS_dinner_checkbox_box gi-mr35">
                        <label>
                            <input type="checkbox" name="prodLineRouteDetailList[${r_index}].lunchFlag" value="Y" class="JS_checkbox_switch JS_dinner_checkbox" <#if r.lunchFlag == 'Y'>checked="checked"</#if> />午餐
                        </label>
                        <input type="text" name="prodLineRouteDetailList[${r_index}].lunchDesc" value="${r.lunchDesc!'敬请自理'}" class="input-text gi-w80 JS_checkbox_disabled JS_dinner_input"
                            <#if r.lunchFlag != 'Y'>disabled="disabled"</#if> data-validate="true" maxlength="100" required/>
                    </span>

                    <span class="JS_checkbox_switch_box JS_dinner_checkbox_box">
                        <label>
                            <input type="checkbox" name="prodLineRouteDetailList[${r_index}].dinnerFlag" value="Y" class="JS_checkbox_switch JS_dinner_checkbox" <#if r.dinnerFlag == 'Y'>checked="checked"</#if> />晚餐
                        </label>
                        <input type="text" name="prodLineRouteDetailList[${r_index}].dinnerDesc" value="${r.dinnerDesc!'敬请自理'}" class="input-text gi-w80 JS_checkbox_disabled JS_dinner_input"
                             <#if r.dinnerFlag != 'Y'>disabled="disabled"</#if> data-validate="true" maxlength="100" required/>
                    </span>

                </div>
            </div>

            <div class="gi-inner-dl clearfix">
                <div class="gi-inner-dt">交通：</div>

                <#if r.trafficType??>
                    <#assign trafficTypes = r.trafficType?split(",") />
                <#else>
                    <#assign trafficTypes = [] />
                </#if>
                <div class="gi-inner-dd">
                    <label class="gi-pr15">
                        <input type="checkbox" name="prodLineRouteDetailList[${r_index}].trafficType" value="PLANE" <#if trafficTypes?? && trafficTypes?seq_contains("PLANE")>checked="checked"</#if> />飞机
                    </label>

                    <label class="gi-pr15">
                        <input type="checkbox" name="prodLineRouteDetailList[${r_index}].trafficType" value="TRAIN" <#if trafficTypes?? && trafficTypes?seq_contains("TRAIN")>checked="checked"</#if> />火车
                    </label>

                    <label class="gi-pr15">
                        <input type="checkbox" name="prodLineRouteDetailList[${r_index}].trafficType" value="BARS" <#if trafficTypes?? && trafficTypes?seq_contains("BARS")>checked="checked"</#if> />巴士
                    </label>

                    <label class="gi-pr15">
                        <input type="checkbox" name="prodLineRouteDetailList[${r_index}].trafficType" value="BOAT" <#if trafficTypes?? && trafficTypes?seq_contains("BOAT")>checked="checked"</#if> />轮船
                    </label>

                    <span class="JS_checkbox_switch_box">
                    <label>
                        <input type="checkbox" name="prodLineRouteDetailList[${r_index}].trafficType" class="JS_checkbox_switch" value="OTHERS" <#if trafficTypes?? && trafficTypes?seq_contains("OTHERS")>checked="checked"</#if> />其他
                    </label>
                    <input type="text" name="prodLineRouteDetailList[${r_index}].trafficOther" value="${r.trafficOther!''}" class="input-text gi-w200 JS_checkbox_disabled" 
                       <#if !(trafficTypes?? && trafficTypes?seq_contains("OTHERS"))>disabled="disabled"</#if> maxlength="100"/>
                    </span>
                </div>

            </div>
            <#if r_index != 0>
            <div class="clearfix">
                <p class="fr gi-mr20">
                    <a href="javascript:" class="gi-del JS_del_day">删除</a>
                </p>
            </div>
            </#if>
            <div class="gi-hr"></div>

    </div>
 