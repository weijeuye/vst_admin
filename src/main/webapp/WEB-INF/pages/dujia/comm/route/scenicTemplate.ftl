<#-- 是否是国内产品标记变量 -->
<#assign innerlineFlag = (productType?? && (productType == "INNERLINE" || productType == "INNERSHORTLINE" || productType == "INNERLONGLINE"))?string("Y","N") />


<!--景点 START-->
<div class="module template-view-spot">

    <!--景点模块头部 START-->
    <div class="module-head clearfix">
        <div class="module-title">景点</div>

        <div class="module-control">
        	<a class="JS_module_prev">上移</a>
            <a class="JS_module_next">下移</a>
            <a class="JS_module_delete">删除</a>
            <a class="module-btn-edit JS_module_edit">编辑</a>
            <a class="btn btn-save JS_module_save">保存</a>
        </div>
    </div>
    <!--景点模块头部 END-->

    <!--景点编辑 START-->
    <div class="edit">
    <form>
        <#-- 组隐藏域DIV -->
        <div class="JS_group_form_hidden" style="display:none">
            <#--行程ID-->
            <input type="hidden" name="routeId" />
            <#--行程明细ID-->
            <input type="hidden" name="detailId" />
            <#--开始时间-->
            <input type="hidden" name="startTime" />
            <#-- 排序值 -->
            <input type="hidden" name="sortValue"/>
            <#--模块类型-->
            <input type="hidden" name="moduleType" value="SCENIC"/>
            <input type='hidden' name='productId' value="${prodLineRoute.productId}"/>
        </div>

        <div class="clearfix">
            <!--模块左侧 START-->
            <div class="module-side">
                <div class="row">
                    <div class="col module-label w70"><em>*</em>开始时间：</div>
                    <div class="col">
                    <p>
                        <span class="JS_time_input">
                            <span class="JS_time_about w20 inline-block">约</span><input type="text" class="form-control hourWidth JS_time_hour" placeholder="小时"
                                   data-validate="{required:true}" maxlength="2">
                            <span class="JS_time_blank">:</span>
                            <input type="text" class="form-control hourWidth JS_time_minute" placeholder="分钟"
                                   data-validate="{required:true}" maxlength="2">
                        </span>
                    </p>

                        <p>
                            <label class="inline-block">
                                <input type="checkbox" name="localTimeFlag" value="Y">
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

    <div class="day-module-add">
        <div class="day-module-add-title">添加行程信息 <i class="triangle"></i></div>
    </div>

</div>
<!--景点 END-->

<!--一个景点 START-->
<div class="view-spot-item" data-index="">

    <#--单个景点下的隐藏域DIV-->
    <div class="JS_item_form_hidden" style="display:none">
         <#--主键ID-->
         <input type="hidden" class="hidden_scenic_id" name="prodRouteDetailScenicList[{{index}}].scenicId" value=""/>
         <#--名称ID-->
         <input type="hidden" class="hidden_scenic_name_id" name="prodRouteDetailScenicList[{{index}}].scenicNameId" value=""/>
         <#--名称-->
         <input type="hidden" class="hidden_scenic_name" name="prodRouteDetailScenicList[{{index}}].scenicName" value="" />
         <#--出行时间-->
         <input type="hidden" class="hidden_travel_time" name="prodRouteDetailScenicList[{{index}}].travelTime" value="" />
         <#--游览时间-->
         <input type="hidden" class="hidden_visit_time" name="prodRouteDetailScenicList[{{index}}].visitTime" value="" />
         <#--参考价格-->
         <input type="hidden" class="hidden_reference_price" name="prodRouteDetailScenicList[{{index}}].referencePrice" value="" />
         <#--模板CODE-->
         <input type="hidden" class="hidden_template_code" name="prodRouteDetailScenicList[{{index}}].templateCode" value="" />
    </div>

    <!--景点模块 添加前 START-->
    <div class="view-spot-initial">
        <div class="row">
            <div class="col w40 JS_view_spot_and_or">
                <select class="form-control w40">
                    <option value="OR">或</option>
                    <option value="AND">和</option>
                </select>
            </div>
            <div class="col w80 module-label">
                前往景点 <em class="text-danger">*</em> ：
            </div>
            <div class="col w410">
                <input type="text" class="form-control w390 JS_view_spot_name" placeholder="请输入景点名称，禁止输入【】<>"
                       maxlength="100" data-validate="{required:true}"/>
            </div>
            <div class="col">
                <input class="btn btn-white JS_view_spot_add" value="添加" type="button"
                       data-validate="{regular:请点击添加或删除多余表单}" data-validate-regular="^[^.]$"/>
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
            <div class="col w40 JS_view_spot_and_or">
                <select class="form-control w40" name="prodRouteDetailScenicList[{{index}}].logicRelateion" >
                    <option value="OR">或</option>
                    <option value="AND">和</option>
                </select>
            </div>
            <a class="JS_view_spot_del">删除</a>
        </div>

        <div class="row">
            <div class="col w80 module-label">
                前往景点 ：
            </div>
            <div class="col w110 JS_scenic_name">
            </div>
            <div class="col">
                <select class="form-control w150" name="prodRouteDetailScenicList[{{index}}].briefExplain">
                    <option value="">请选择</option>
                    <option value="OUTSIDE_SEE">外观，此景点不含门票费用</option>
                    <option value="TICKET_COST_INCLUDE">此景点有门票景点费用</option>
                    <option value="TICKET_COST_EXCLUDE">此景点无门票景点费用</option>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="col w110">
                <select class="form-control w80 JS_view_spot_include" name="prodRouteDetailScenicList[{{index}}].scenicExplain">
                    <option value="ROUTE_INCLUDED">行程已含</option>
                    <option value="GIVING">赠送景点</option>
                    <#if innerlineFlag == 'N'>
                         <option value="SELF_PAYING">自费景点</option>
                         <option value="RECOMMEND">推荐景点</option>
                    </#if>
                </select>
            </div>
            <div class="col module-label w80">
                参考价格 <em class="JS_view_spot_price_label none">*</em> ：
            </div>
            <div class="col w80">
                <input type="text" class="form-control w60 JS_view_spot_price" data-validate="{regular:仅支持输入数字}" data-validate-regular="^\d*$" maxlength="5"/>
            </div>
            <div class="col w80">
                <select class="form-control w70" name="prodRouteDetailScenicList[{{index}}].currency">
                    <#list currencys as currency>
                        <option value="${currency.name()!''}">${currency.cnName!''}</option>
                    </#list>
                </select>
            </div>
            <div class="col">
                <input type="text" class="form-control w300" name="prodRouteDetailScenicList[{{index}}].otherFeesTip" placeholder="小交通、索道、二次门票等其他服务包含提示" maxlength="100">
            </div>
        </div>
        <div class="row">
            <div class="col w110">
                <select class="form-control w80 JS_activity_time" name="prodRouteDetailScenicList[{{index}}].travelType">
                    <option value="DRIVE">行驶时间</option>
                    <option value="WALK">徒步时间</option>
                </select>
            </div>
            <div class="col w160">
                 约
                <input type="text" class="form-control w30 JS_travel_hour" data-validate="{regular:仅支持输入数字}" data-validate-regular="^\d*$" maxlength="2"/>
                小时
                <input type="text" class="form-control w30 JS_travel_minute" data-validate="{regular:仅支持输入数字}" data-validate-regular="^\d*$" maxlength="2"/>
                分钟
            </div>
            <div class="col module-label w60 JS_activity_distance">
                行驶距离
            </div>
            <div class="col w110">
                约
                <input type="text" class="form-control w30" name="prodRouteDetailScenicList[{{index}}].distanceKM" data-validate="{regular:仅支持输入数字}" data-validate-regular="^\d*$" maxlength="4"/>
                公里
            </div>
            <div class="col module-label w70">
                <em class="JS_visit_time_em"></em>游览时间：
            </div>
            <div class="col">
                 约
                <input type="text" class="form-control w30 JS_visit_hour" data-validate="{regular:仅支持输入数字}" data-validate-regular="^\d*$" maxlength="2"/>
                小时
                <input type="text" class="form-control w30 JS_visit_minute" data-validate="{regular:仅支持输入数字}" data-validate-regular="^\d*$" maxlength="2"/>
                分钟
            </div>
        </div>
        <div class="row">
            <div class="col module-label w90">
                话术模板 <i class="icon icon-help" data-poptip="话术模板可以将你所填的内容整合成较为易懂的一段话"></i> ：
            </div>
            <div class="col">
                <label>
                    <input type="checkbox" class="JS_use_template_flag" checked="checked" name="prodRouteDetailScenicList[{{index}}].useTemplateFlag" value="Y"/>
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
                        <textarea class="form-control textarea-content" name="prodRouteDetailScenicList[{{index}}].scenicDesc" maxlength="1000"></textarea>
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
<!--一个景点 END-->