<#--定义是否为新结构标记变量-->
<#assign newStructureFlag = (prodLineRoute?? && prodLineRoute.newStructureFlag == "N")?string("N","Y") />

<#-- 是否是国内产品标记变量 -->
<#assign innerlineFlag = (productType?? && (productType == "INNERLINE" || productType == "INNERSHORTLINE" || productType == "INNERLONGLINE"))?string("Y","N") />

<#--景点 START-->
<div class="module template-view-spot <#if newStructureFlag == "Y">state-view<#else>state-edit</#if>" data-id="${routeDetailGroup.groupId}">

    <!--景点模块头部 START-->
    <div class="module-head clearfix">
        <div class="module-title">景点</div>

        <div class="module-control">
        	<a class="JS_module_prev">上移</a>
            <a class="JS_module_next">下移</a>
            <a class="JS_module_delete">删除</a>
            <a class="module-btn-edit JS_module_edit">编辑</a>
            <#if newStructureFlag == "Y">
            <a class="btn btn-save JS_module_save">保存</a>
            </#if>
        </div>
    </div>
    <!--景点模块头部 END-->

    <!--景点查看 START-->
    <div class="view">

        <div class="module-post clearfix">

            <div class="module-post-left">
                <p><#if routeDetailGroup.startTime != "ALL_DAY">${routeDetailGroup.getTimeType()!''}</#if></p>
                <#if routeDetailGroup.localTimeFlag == "Y"><p class="text-gray module-local-time">当地时间</p></#if>
            </div>

            <div class="module-post-right">
            <#if routeDetailGroup.prodRouteDetailScenicList?? && routeDetailGroup.prodRouteDetailScenicList?size &gt; 0>
            <#list routeDetailGroup.prodRouteDetailScenicList as item>
                <div class="module-post-content">
                <i class="icon-state icon-state-view-spot"></i>

                <#if item.useTemplateFlag == "Y">
                <#-- 话术模板展示 开始 -->
                <div class="view-content-new">
                    <div class="row">
                        <#if item_index != 0 && item.logicRelateion != "">
                        <span class="text-danger">（<#if item.logicRelateion == "AND">和<#elseif item.logicRelateion == "OR">或</#if>）</span>
                        </#if>

                        <#if item.templateText??>
                        ${item.templateText?replace('【', '<span class="font-big">')?replace('】', '</span>')?replace("\n", "<br/>")}
                        </#if>
                    </div>
                </div>
                <#-- 话术模板展示 结束 -->
                <#else>
                <#-- 非话术模板展示 开始 -->
                <h3>
                    <#if item_index != 0 && item.logicRelateion != "">
                    <span class="text-danger">（<#if item.logicRelateion == "AND">和<#elseif item.logicRelateion == "OR">或</#if>）</span>
                    </#if>
                    ${item.scenicName!''}
                    <small>${routeDetailFormat.getBriefExplainCnName(item.briefExplain)!''}</small>
                </h3>
                <div class="view-content-new">

                    <#-- 行驶的时间与距离 -->
                    <#if item.travelTime != "" || item.distanceKM != "" || item.visitTime != "">
                    <div class="row">
                        <!-- 出行时间 -->
                        <#assign travelTypeStr = routeDetailFormat.getTravelTypeCnName(item.travelType)/>
                        <#assign travelTimeStr = routeDetailFormat.getTimeStr(item.travelTime)/>
                        <#if travelTypeStr != "" && travelTimeStr != "">
                        <div class="col w65">
                            ${travelTypeStr!''}时间：
                        </div>
                        <div class="col row-inline-mr25">
                            ${travelTimeStr!''}
                        </div>
                        </#if>

                        <!-- 行程距离 -->
                        <#if travelTypeStr != "" && item.distanceKM != "">
                        <div class="col w65">
                            ${travelTypeStr!''}距离：
                        </div>
                        <div class="col row-inline-mr25">
                            约${item.distanceKM!''}公里
                        </div>
                        </#if>

                        <!-- 游览时间 -->
                        <#assign visitTimeStr = routeDetailFormat.getTimeStr(item.visitTime)/>
                        <#if visitTimeStr != "">
                        <div class="col w65">
                            游览时间：
                        </div>
                        <div class="col row-inline-mr25">
                            ${visitTimeStr!''}
                        </div>
                        </#if>
                    </div>
                    </#if>

                    <#-- 景点费用说明 -->
                    <#assign sceneryExplainCnName = routeDetailFormat.getSceneryExplainCnName(item.scenicExplain)!'' />
                    <#assign cnPriceFormat = routeDetailFormat.getCnPriceFormat(item.referencePrice, item.currency, 'SCENIC')!'' />

                    <#if !(item.scenicExplain == "ROUTE_INCLUDED" && cnPriceFormat == "" && item.otherFeesTip == "")>
                    <div class="row">
                        <#if item.scenicExplain != "ROUTE_INCLUDED">
                        <div class="col w65">${sceneryExplainCnName}<#if cnPriceFormat != "">：<#else>&nbsp;&nbsp;</#if></div>
                        </#if>
                        <div class="col w700">
                            <!-- 参考价格 -->             <!-- 其他费用提示 -->
                            ${cnPriceFormat!''}  ${item.otherFeesTip!''}
                        </div>
                    </div>
                    </#if>

                    <#-- 景点描述 -->
                    <#if item.scenicDesc != "">
                    <div class="row">
                        ${item.scenicDesc?replace("\n", "<br/>")}
                    </div>
                    </#if>
                </div>
                <#-- 非话术模板展示 结束 -->
                </#if>
                </div>
            </#list>
            </#if>
            </div>
        </div>
    </div>
    <!--景点查看 END-->

    <!--景点编辑 START-->
    <div class="edit">
    <form>
        <#-- 组隐藏域DIV -->
        <div class="JS_group_form_hidden" style="display:none">
            <#--行程ID-->
            <input type="hidden" name="routeId" value="${routeDetailGroup.routeId}" />
            <#--行程明细ID-->
            <input type="hidden" name="detailId" value="${routeDetailGroup.detailId}" />
            <#--组ID-->
            <input type="hidden" name="groupId" value="${routeDetailGroup.groupId}" />
            <#--开始时间-->
            <input type="hidden" name="startTime" value="${routeDetailGroup.startTime}" />
            <#-- 排序值 -->
            <input type="hidden" name="sortValue" value="${routeDetailGroup.sortValue}"/>
            <#--模块类型-->
            <input type="hidden" name="moduleType" value="SCENIC"/>
        </div>

        <div class="clearfix">
            <!--模块左侧 START-->
            <div class="module-side">

                <#-- 组的开始时间-->
                <#if routeDetailGroup.startTime?? && routeDetailGroup.startTime?contains(":")>
                    <#assign hasColon = "Y"/>
                    <#assign startTime = routeDetailGroup.startTime?split(":")/>
                <#else>
                    <#assign hasColon = "N"/>
                </#if>

                <div class="row">
                    <div class="col module-label w70"><em>*</em>开始时间：</div>
                    <div class="col">
                        <p>
                            <span class="JS_time_input">
                            <span class="JS_time_about w20 inline-block">约</span>
                                <input type="text" class="form-control hourWidth JS_time_hour" value="<#if hasColon == "Y">${startTime[0]!''}<#else>${routeDetailGroup.getTimeType()!''}</#if>"
                                       placeholder="小时" data-validate="{required:true}" maxlength="2">
                                <span class="JS_time_blank" <#if hasColon == "N">style="display:none;"</#if> >:</span>
                                <input type="text" class="form-control w30 JS_time_minute" <#if hasColon == "N">disabled style="display:none;"</#if> value="<#if hasColon == "Y">${startTime[1]!''}</#if>"
                                 placeholder="分钟" data-validate="{required:true}" maxlength="2">
                            </span>
                        </p>

                        <p>
                            <label class="inline-block">
                                <input type="checkbox" name="localTimeFlag" value="Y" <#if routeDetailGroup.localTimeFlag=="Y">checked="checked"</#if> >
                                当地时间
                            </label>
                        </p>
                    </div>
                </div>
            </div>
            <!--模块左侧  END-->

            <!--模块右侧 START-->
            <div class="module-main">

                <div class="view-spot-list">
                    <#-- 景点子项循环START-->
                    <#if routeDetailGroup.prodRouteDetailScenicList?? && routeDetailGroup.prodRouteDetailScenicList?size &gt; 0>
                    <#list routeDetailGroup.prodRouteDetailScenicList as item>
                        <div class="view-spot-item state-added" data-index="${item_index}">

                            <#--单个景点下的隐藏域DIV-->
                            <div class="JS_item_form_hidden" style="display:none">
                                 <#--主键ID-->
                                 <input type="hidden" class="hidden_scenic_id" name="prodRouteDetailScenicList[${item_index}].scenicId" value="${item.scenicId}"/>
                                 <#--名称ID-->
                                 <input type="hidden" class="hidden_scenic_name_id" name="prodRouteDetailScenicList[${item_index}].scenicNameId" value="${item.scenicNameId}" />
                                 <#--组ID-->
                                 <input type="hidden" name="groupId" name="prodRouteDetailScenicList[${item_index}].groupId" value="${item.groupId}" />
                                 <#--名称-->
                                 <input type="hidden" class="hidden_scenic_name" name="prodRouteDetailScenicList[${item_index}].scenicName" value="${item.scenicName}" />
                                 <#--出行时间-->
                                 <input type="hidden" class="hidden_travel_time" name="prodRouteDetailScenicList[${item_index}].travelTime" value="${item.travelTime}" />
                                 <#--游览时间-->
                                 <input type="hidden" class="hidden_visit_time" name="prodRouteDetailScenicList[${item_index}].visitTime" value="${item.visitTime}" />
                                 <#--参考价格-->
                                 <input type="hidden" class="hidden_reference_price" name="prodRouteDetailScenicList[${item_index}].referencePrice" value="${item.referencePrice}" />
                                 <#--模板CODE-->
                                 <input type="hidden" class="hidden_template_code" name="prodRouteDetailScenicList[${item_index}].templateCode" value="${item.templateCode}" />
                            </div>

                            <!--景点模块 添加前 START-->
                            <div class="view-spot-initial">
                                <div class="row">
                                    <div class="col w40 JS_view_spot_and_or">
                                        <select class="form-control w40">
                                            <option value="OR" <#if item.logicRelateion=="OR">selected</#if> >或</option>
                                            <option value="AND" <#if item.logicRelateion=="AND">selected</#if> >和</option>
                                        </select>
                                    </div>
                                    <div class="col w80 module-label">
                                                                                                                          前往景点 <em class="text-danger">*</em> ：
                                    </div>
                                    <div class="col w410">
                                        <input type="text" class="form-control w390 JS_view_spot_name" value="${item.scenicName!''}" placeholder="请输入景点名称"
                                               maxlength="100" data-validate="{required:true}" disabled/>
                                    </div>
                                    <div class="col">
                                        <input class="btn btn-white JS_view_spot_add" value="添加" type="button"
                                               data-validate="{regular:请点击添加或删除多余表单}" data-validate-regular="^[^.]$" disabled/>
                                    </div>
                                    <div class="col view-spot-del-box">
                                        <a class="JS_view_spot_del">删除</a>
                                    </div>
                                </div>
                            </div>
                            <!--景点模块 添加前 END-->

                            <!--景点模块 添加后 START-->
                            <div class="view-spot-form">

                                <div class="view-spot-head">
                                    <#if item_index != 0>
                                    <div class="col w40 JS_view_spot_and_or">
                                        <select class="form-control w40" name="prodRouteDetailScenicList[${item_index}].logicRelateion" >
                                            <option value="OR" <#if item.logicRelateion=="OR">selected</#if> >或</option>
                                            <option value="AND" <#if item.logicRelateion=="AND">selected</#if> >和</option>
                                        </select>
                                    </div>
                                    </#if>
                                    <a class="JS_view_spot_del">删除</a>
                                </div>

                                <div class="row">
                                    <div class="col w80 module-label">
                                        前往景点 ：
                                    </div>
                                    <div class="col w110 JS_scenic_name">
                                        ${item.scenicName!''}
                                    </div>
                                    <div class="col">
                                        <select class="form-control w150" name="prodRouteDetailScenicList[${item_index}].briefExplain">
                                            <option value="">请选择</option>
                                            <option value="OUTSIDE_SEE" <#if item.briefExplain=="OUTSIDE_SEE">selected</#if> >外观，此景点不含门票费用</option>
                                            <option value="TICKET_COST_INCLUDE" <#if item.briefExplain=="TICKET_COST_INCLUDE">selected</#if> >此景点有门票景点费用</option>
                                            <option value="TICKET_COST_EXCLUDE" <#if item.briefExplain=="TICKET_COST_EXCLUDE">selected</#if> >此景点无门票景点费用</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col w110">
                                        <select class="form-control w80 JS_view_spot_include" data-validate="{required:true}" name="prodRouteDetailScenicList[${item_index}].scenicExplain">
                                            <#if innerlineFlag != 'Y'>
                                                <option value="SELF_PAYING" <#if item.scenicExplain=="SELF_PAYING">selected</#if>>自费景点</option>
                                                <option value="RECOMMEND" <#if item.scenicExplain=="RECOMMEND">selected</#if> >推荐景点</option>
                                            <#elseif innerlineFlag == 'Y' && (item.scenicExplain=="SELF_PAYING" || item.scenicExplain=="RECOMMEND")>
                                                <option></option>
                                            </#if>
                                            <option value="ROUTE_INCLUDED" <#if item.scenicExplain=="ROUTE_INCLUDED">selected</#if> >行程已含</option>
                                            <option value="GIVING" <#if item.scenicExplain=="GIVING">selected</#if> >赠送景点</option>
                                        </select>
                                    </div>
                                    <div class="col module-label w80">
                                                                                                                            参考价格 <em class="JS_view_spot_price_label none" <#if item.scenicExplain=="SELF_PAYING">style="display: inline;"</#if> >*</em> ：
                                    </div>
                                    <div class="col w80">
                                        <input type="text" class="form-control w60 JS_view_spot_price" value="${routeDetailFormat.formatPrice(item.referencePrice)!''}" data-validate="{regular:仅支持输入数字}" data-validate-regular="^\d*$" maxlength="5"
                                        <#if item.scenicExplain=="ROUTE_INCLUDED" || item.scenicExplain=="GIVING">disabled</#if> />
                                    </div>
                                    <div class="col w80">
                                        <select class="form-control w70" name="prodRouteDetailScenicList[${item_index}].currency"">
                                            <#list currencys as currency>
                                                <option value="${currency.name()!''}" <#if currency.name()==item.currency>selected</#if> >${currency.cnName!''}</option>
                                            </#list>
                                        </select>
                                    </div>
                                    <div class="col">
                                        <input type="text" class="form-control w300" name="prodRouteDetailScenicList[${item_index}].otherFeesTip" value="${item.otherFeesTip!''}" placeholder="小交通、索道、二次门票等其他服务包含提示" maxlength="100">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col w110">
                                        <select class="form-control w80 JS_activity_time" name="prodRouteDetailScenicList[${item_index}].travelType">
                                            <option value="DRIVE" <#if item.travelType=="DRIVE">selected</#if> >行驶时间</option>
                                            <option value="WALK" <#if item.travelType=="WALK">selected</#if> >徒步时间</option>
                                        </select>
                                    </div>

                                    <#-- 出行时间 -->
                                    <#if item.travelTime?? && item.travelTime != null>
                                        <#assign travelTime = item.travelTime?split(":")/>
                                    <#else>
                                        <#assign travelTime = ['','']/>
                                    </#if>

                                    <div class="col w170">
                                        约
                                        <input type="text" class="form-control w30 JS_travel_hour" value="${travelTime[0]!''}" data-validate="{regular:仅支持输入数字}" data-validate-regular="^\d*$" maxlength="2"/>
                                        小时
                                        <input type="text" class="form-control w30 JS_travel_minute" value="${travelTime[1]!''}" data-validate="{regular:仅支持输入数字}" data-validate-regular="^\d*$" maxlength="2"/>
                                        分钟
                                    </div>
                                    <#if item.travelType=="WALK">
                                        <div class="col module-label w80 JS_activity_distance">
                                                  徒步距离
                                        </div>
                                    <#else>
                                         <div class="col module-label w60 JS_activity_distance">
                                                行驶距离
                                        </div>
                                    </#if>
                                    <div class="col w120">
                                        约
                                        <input type="text" class="form-control w30" name="prodRouteDetailScenicList[${item_index}].distanceKM" value="${item.distanceKM}" data-validate="{regular:仅支持输入数字}" data-validate-regular="^\d*$" maxlength="4"/>
                                        公里
                                    </div>

                                    <#-- 游览时间 -->
                                    <#if item.visitTime?? && item.visitTime != null>
                                        <#assign visitTime = item.visitTime?split(":")/>
                                    <#else>
                                        <#assign visitTime = ['','']/>
                                    </#if>

                                    <div class="col module-label w70">
                                        <em class="JS_visit_time_em"><#if innerlineFlag == "Y">*</#if></em>游览时间：
                                    </div>
                                    <div class="col">
                                       约
                                        <input type="text" class="form-control w30 JS_visit_hour" value="${visitTime[0]!''}" data-validate=<#if innerlineFlag == "Y">"{required:true,regular:仅支持输入数字}"<#else>"{regular:仅支持输入数字}"</#if> data-validate-regular="^\d*$" maxlength="2"/>
                                        小时
                                        <input type="text" class="form-control w30 JS_visit_minute" value="${visitTime[1]!''}" data-validate=<#if innerlineFlag == "Y">"{required:true,regular:仅支持输入数字}"<#else>"{regular:仅支持输入数字}"</#if> data-validate-regular="^\d*$" maxlength="2"/>
                                        分钟
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col module-label w90">
                                        话术模板 <i class="icon icon-help" data-poptip="话术模板可以将你所填的内容整合成较为易懂的一段话"></i> ：
                                    </div>
                                    <div class="col">
                                        <label>
                                            <input type="checkbox" class="JS_use_template_flag" name="prodRouteDetailScenicList[${item_index}].useTemplateFlag" value="Y" <#if item.useTemplateFlag=="Y">checked</#if> />
                                            使用系统提供的话术模板来显示信息
                                        </label>
                                        <a class="JS_view_sport_preview">预览查看</a>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col module-label w70">
                                        景点说明 ：
                                    </div>
                                    <div class="col">
                                        <div class="col JS_textares_box">
                                            <a class="textarea-content-expand JS_textarea_expand" data-text="展开景点说明">
                                                添加景点说明
                                                <i class="triangle"></i>
                                            </a>

                                            <div>
                                                <textarea class="form-control textarea-content" name="prodRouteDetailScenicList[${item_index}].scenicDesc" maxlength="1000">${item.scenicDesc!''}</textarea>
                                            </div>

                                            <a class="textarea-content-shrink JS_textarea_shrink">
                                                收起景点说明
                                                <i class="triangle"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!--景点模块 添加后 END-->

                        </div>
                    </#list>
                    </#if>
                    <#-- 景点子项循环END-->
                </div>

                <div class="view-spot-increase">
                    <a class="btn btn-white JS_view_spot_increase">
                        <span class="icon-add-item"></span>
                        增加景点
                    </a>
                </div>

            </div>
            <!--模块右侧 END-->
        </div>

    </form>
    </div>
    <!--景点编辑 END-->

    <div class="day-module-add" <#if newStructureFlag=='N'>style="display:none"</#if>  >
        <div class="day-module-add-title">添加行程信息 <i class="triangle"></i></div>
    </div>

</div>
<#--景点 END-->