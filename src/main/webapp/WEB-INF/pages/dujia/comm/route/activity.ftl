 <#--定义是否为新结构标记变量-->
<#assign newStructureFlag = (prodLineRoute?? && prodLineRoute.newStructureFlag == "N")?string("N","Y") />

<#--定义活动对象-->
<#if routeDetailGroup.prodRouteDetailActivityList?? && routeDetailGroup.prodRouteDetailActivityList?size &gt; 0>
    <#assign routeDetailActivity = routeDetailGroup.prodRouteDetailActivityList[0] />
<#else>
    <#assign routeDetailActivity = prodRouteDetailActivityEmpty />
</#if>

 <#--自由活动 START-->
    <div class="module template-activity <#if newStructureFlag == "Y">state-view<#else>state-edit</#if>" data-id="${routeDetailGroup.groupId}">

        <div class="module-head clearfix">
            <div class="module-title"><#if routeDetailGroup?? && routeDetailGroup.moduleType == "OTHER_ACTIVITY">其他活动<#else>自由活动</#if></div>

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

        <!--自由活动查看 START-->
        <div class="view">

            <div class="module-post clearfix">

                <div class="module-post-left">
                    <p><#if routeDetailGroup.startTime != "ALL_DAY">${routeDetailGroup.getTimeType()!''}</#if></p>
                    <#if routeDetailGroup.localTimeFlag =="Y">
                         <p class="text-gray module-local-time">当地时间</p>
                    </#if>
                </div>
                <div class="module-post-right">
                    <div class="module-post-content">
                        <i class="icon-state icon-state-activity"></i>
                            <#if routeDetailGroup.moduleType == "OTHER_ACTIVITY">
                                <h3><#if routeDetailActivity.activityName != ''>${routeDetailActivity.activityName!''}</#if></h3>
                            </#if>
                        <div class="view-content-new">
                            <div class="row">
                                <!--活动时间 -->
                                <#assign visitTimeDesc = routeDetailFormat.getTimeStr(routeDetailActivity.visitTime)/>
                                <#if visitTimeDesc != "">
                                <div class="col w65">
                                                                                                            活动时间：
                                </div>
                                <div class="col row-inline-mr25">
                                    ${visitTimeDesc!''}  
                                </div>
                                </#if>
                                <div class="col w65">
                                </div>
                                <div class="col row-inline-mr25">
                                <!-- 行驶 或者 徒步 时间 -->
                                <#assign travelTimeDesc = routeDetailFormat.getCnTimeFormat(routeDetailActivity.travelType,routeDetailActivity.travelTime)/>
                                <#if travelTimeDesc != "">
                                     ${travelTimeDesc!''}  
                                </#if>
                                </div>
                                <div class="col w65">
                                </div>
                                <div class="col row-inline-mr25">
                                <!-- 行驶 或者 徒步 距离 -->
                                <#assign distanceKmDesc = routeDetailFormat.getCnDistanceFormat(routeDetailActivity.travelType,routeDetailActivity.distanceKm)/>
                                <#if distanceKmDesc != "">
                                     ${distanceKmDesc!''}  
                                </#if>
                                </div>
                            </div>
                            <#if routeDetailActivity.activityDesc != "">
                            <div class="row">
                                <div class="col w65">
                                                                                                                
                                </div>
                                <div class="col w700">
                                    ${routeDetailActivity.activityDesc?replace('\n','<br/>')}
                                </div>
                            </div>
                            </#if>
                        </div>
                    </div>
                </div>

            </div>
        </div>
        <!--自由活动查看 END-->

        <!--自由活动编辑 START-->
        <div class="edit">
          <form>
            <#-- 组隐藏域DIV -->
            <div class="JS_group_form_hidden">
                  <input type="hidden" name="routeId" value="${routeDetailGroup.routeId}" />
                  <input type="hidden" name="detailId" value="${routeDetailGroup.detailId}" />
                  <input type="hidden" name="groupId" value="${routeDetailGroup.groupId}" />
                  <input type="hidden" name="startTime" value="${routeDetailGroup.startTime}" />
                  <input type="hidden" name="moduleType" value="${routeDetailGroup.moduleType}"/>
                  <input type="hidden" name="sortValue" value="${routeDetailGroup.sortValue}"/>
            </div>
            <div class="clearfix">
                <!--模块左侧 START-->
                <div class="module-side">
                <#-- 组的开始时间-->
                <#if routeDetailGroup.startTime?? && routeDetailGroup.startTime?contains(":")>
                    <#assign hasColon = "Y"/>
                    <#assign groupStartTime = routeDetailGroup.startTime?split(":")/>
                <#else>
                    <#assign hasColon = "N"/>
                </#if>
                    <div class="row">
                        <div class="col module-label w70"><em>*</em>开始时间：</div>
                        <div class="col">
                            <p>
                                <span class="JS_time_input">

                                <span class="JS_time_about">约</span>
                                    <input type="text" class="form-control hourWidth JS_time_hour" placeholder="小时"
                                       data-validate="{required:true}" maxlength="2" value="<#if hasColon == "Y">${groupStartTime[0]!''}<#else>${routeDetailGroup.getTimeType()!''}</#if>"/>
                                <span class="JS_time_blank" <#if hasColon == "N">style="display:none;"</#if> >:</span>
                                    <input type="text" class="form-control w30 JS_time_minute" placeholder="分钟"
                                       data-validate="{required:true}" <#if hasColon == "N">disabled style="display:none;"</#if> value="<#if hasColon == "Y">${groupStartTime[1]!''}</#if>" maxlength="2"/>
                                </span>
                            </p>

                            <p>
                                <label>
                                    <input type="checkbox" name="localTimeFlag" value="Y" <#if routeDetailGroup.localTimeFlag =="Y">checked="checked"</#if> /> 当地时间
                                </label>
                            </p>
                        </div>
                    </div>
                </div>
                <!--模块左侧 END-->

                <!--模块右侧 START-->
                <div <#if productType!="FOREIGNLINE" && categoryId!=18 >class="module-main activity-item "<#else>class="module-main "</#if>>
                <#--单个活动模块下的隐藏域DIV-->
                <div class="JS_item_form_hidden" style="display:none">
                     <#--行驶时间-->
                     <input type="hidden" class="hidden_travel_time" name="prodRouteDetailActivityList[0].travelTime" value="${routeDetailActivity.travelTime}"/>
                     <#--活动时间-->
                     <input type="hidden" class="hidden_visit_time" name="prodRouteDetailActivityList[0].visitTime" value="${routeDetailActivity.visitTime}"/>
                </div>
                 <#if routeDetailGroup.moduleType == "OTHER_ACTIVITY">
                      <div class="row">
                           <div class="col module-label w80">
                                                                                                 活动标题 ：
                           </div>
                           <div class="col">
                                <input type="text" class="form-control w300" placeholder="输入活动标题" maxlength="100" name="prodRouteDetailActivityList[0].activityName" value="${routeDetailActivity.activityName!''}" />
                           </div>
                     </div>
                 </#if>
                 <#-- 活动模块的活动时间 -->
                <#if routeDetailActivity.visitTime?? && routeDetailActivity.visitTime != null>
                    <#assign visitTime = routeDetailActivity.visitTime?split(":")/>
                <#else>
                    <#assign visitTime = ['','']/>
                </#if>
                    <div class="row">
                    <input type="hidden" id="categoryId" name="categoryId" value="${categoryId!''}"/>
                        <div class="col module-label w80"><#if productType!="FOREIGNLINE" && categoryId != '18' ><em>*</em></#if>活动时间：</div>
                        <div class="col w200">
                                                                                     约 <input type="text" class="form-control w30 JS_visit_hour" <#if productType!="FOREIGNLINE" && categoryId!='18' > data-validate="{required:true,regular:true}"<#else>data-validate="{regular:true}"</#if> data-validate-regular="^\d*$" maxlength="2" value="${visitTime[0]!''}">
                                                                                  小时 <input type="text" class="form-control w30 JS_visit_minute" <#if productType!="FOREIGNLINE" && categoryId!='18' > data-validate="{required:true,regular:true}"<#else>data-validate="{regular:true}"</#if> data-validate-regular="^\d*$" maxlength="2" value="${visitTime[1]!''}">  分钟
                        </div>
                        <div class="col module-label">
                            <select class="form-control w80 JS_activity_time" name="prodRouteDetailActivityList[0].travelType" value="">
                                    <option value="DRIVE" <#if routeDetailActivity.travelType == "DRIVE">selected</#if> >行驶时间</option>
                                    <option value="WALK" <#if routeDetailActivity.travelType == "WALK">selected</#if> >徒步时间</option>
                            </select> ：
                        </div>
                        <#-- 活动模块的行驶时间 -->
                        <#if routeDetailActivity.travelTime?? && routeDetailActivity.travelTime != null>
                             <#assign travelTime = routeDetailActivity.travelTime?split(":")/>
                        <#else>
                             <#assign travelTime = ['','']/>
                        </#if>
                        <div class="col w200">
                                                                                      约<input type="text" class="form-control w30 JS_travel_hour" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2" value="${travelTime[0]!''}">
                                                                                     小时<input type="text" class="form-control w30 JS_travel_minute" data-validate="{regular:true}" data-validate-regular="^\d*$" maxlength="2" value="${travelTime[1]!''}"> 分钟
                        </div>
                        <div class="col module-label">
                            <span class="JS_activity_distance" value="${!''}"><#if routeDetailActivity.travelType?? && routeDetailActivity.travelType == "WALK">徒步<#else>行驶</#if>距离</span> ：
                        </div>
                        <div class="col">
                                                                                      约     <input type="text" class="form-control w30" name="prodRouteDetailActivityList[0].distanceKm" value="${routeDetailActivity.distanceKm!''}" data-validate="{regular:true}" 
                               data-validate-regular="^\d*$" maxlength="4" > 公里
                        </div>
                    </div>
                    <div class="row">
                        <div class="col module-label w70">活动内容：</div>
                        <div class="col JS_textares_box">
                            <a class="textarea-content-expand JS_textarea_expand">展开活动说明 <i class="triangle"></i></a>
                                 <textarea class="form-control textarea-content" name="prodRouteDetailActivityList[0].activityDesc" value="${routeDetailActivity.activityDesc!''}" maxlength="1000" >${routeDetailActivity.activityDesc!''}</textarea>
                            <a class="textarea-content-shrink JS_textarea_shrink">收起活动说明 <i class="triangle"></i></a>
                        </div>
                    </div>
                </div>
                <!--模块右侧 END-->
            </div>
           </form>
        </div>
        <!--自由活动编辑 END-->

        <div class="day-module-add" <#if newStructureFlag=='N'>style="display:none"</#if> >
            <div class="day-module-add-title">添加行程信息 <i class="triangle"></i></div>
        </div>

    </div>
    <#--自由活动 END-->