<#--活动 START-->
<div class="module template-activity">

    <div class="module-head clearfix">
        <div class="module-title">其他活动</div>

        <div class="module-control">
        	<a class="JS_module_prev">上移</a>
            <a class="JS_module_next">下移</a>
            <a class="JS_module_delete">删除</a>
            <a class="module-btn-edit JS_module_edit">编辑</a>
            <a class="btn btn-save JS_module_save">保存</a>
        </div>
    </div>

    <!--活动编辑 START-->
    <div class="edit">
    <form>
        <#-- 组隐藏域DIV -->
        <div class="JS_group_form_hidden">
            <input type="hidden" name="routeId" />
            <input type="hidden" name="detailId" />
            <input type="hidden" name="startTime" />
            <input type="hidden" name="moduleType" value = "OTHER_ACTIVITY"/>
            <input type="hidden" name="sortValue" />
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
                        <span class="JS_time_about">约</span>
                                <input type="text" class="form-control hourWidth JS_time_hour" name="startHourTime" placeholder="小时"
                                       data-validate="{required:true}" maxlength="2">
                                <span class="JS_time_blank">:</span>
                                <input type="text" class="form-control hourWidth JS_time_minute" name="startMinuteTime" placeholder="分钟"
                                       data-validate="{required:true}" maxlength="2">
                            </span>
                        </p>
                        <p>
                            <label>
                                <input type="checkbox" name="localTimeFlag" value="Y">
                                    当地时间
                            </label>
                        </p>
                    </div>
                </div>
            </div>
            <!--模块左侧 END-->

            <!--模块右侧 START-->
            <div class="module-main">

                <#--单个活动模块下的隐藏域DIV-->
                <div class="JS_item_form_hidden" style="display:none">
                	 <#--行驶时间-->
               		 <input type="hidden" class="hidden_travel_time" name="prodRouteDetailActivityList[0].travelTime" value=""/>
                     <#--活动时间-->
                     <input type="hidden" class="hidden_visit_time" name="prodRouteDetailActivityList[0].visitTime" value=""/>
                </div>

               <div class="row JS_title_row">
                        <div class="col module-label w80">
                                活动标题 ：
                        </div>
                        <div class="col">
                            <input type="text" class="form-control w300" placeholder="输入活动标题" maxlength="100" name="prodRouteDetailActivityList[0].activityName"/>
                        </div>
                </div>
                <div class="row">
                    <div class="col module-label w80">活动时间：</div>
                    <div class="col w200">
                            约
                        <input type="text" class="form-control w30 JS_visit_hour" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2">
                                                                        小时
                        <input type="text" class="form-control w30 JS_visit_minute" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2"> 
                            分钟
                    </div>
                    <div class="col module-label">
                        <select class="form-control w80 JS_activity_time" name="prodRouteDetailActivityList[0].travelType">
                            <option value="DRIVE">行驶时间</option>
                            <option value="WALK">徒步时间</option>
                        </select>
                            ：
                    </div>
                    <div class="col w200">
                                                                         约
                        <input type="text" class="form-control w30 JS_travel_hour" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2">
                             小时
                        <input type="text" class="form-control w30 JS_travel_minute" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2">
                            分钟
                    </div>
                    <div class="col module-label">
                        <span class="JS_activity_distance" name="travelType">行驶距离</span>
                            ：
                    </div>
                    <div class="col">
                            约
                        <input type="text" class="form-control w30" data-validate="{regular:true}" name="prodRouteDetailActivityList[0].distanceKm" data-validate-regular="^\d*$" maxlength="4">
                            公里
                    </div>
                </div>
                <div class="row">
                    <div class="col module-label w80">活动内容：</div>
                    <div class="col JS_textares_box">
                        <a class="textarea-content-expand JS_textarea_expand">展开活动说明 <i class="triangle"></i></a>
                        <textarea class="form-control textarea-content" maxlength="1000" name="prodRouteDetailActivityList[0].activityDesc"></textarea>
                        <a class="textarea-content-shrink JS_textarea_shrink">收起活动说明 <i class="triangle"></i></a>
                    </div>
                </div>
            </div>
            <!--模块右侧 END-->
        </div>

   </form>   
</div>
    <!--活动编辑 END-->

    <div class="day-module-add">
        <div class="day-module-add-title">添加行程信息 <i class="triangle"></i></div>
    </div>

</div>
<#--活动 END-->