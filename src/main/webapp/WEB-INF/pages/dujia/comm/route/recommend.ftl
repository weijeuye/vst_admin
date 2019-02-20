 <#--定义是否为新结构标记变量-->
<#assign newStructureFlag = (prodLineRoute?? && prodLineRoute.newStructureFlag == "N")?string("N","Y") />

<#--定义推荐模块对象-->
<#if routeDetailGroup.prodRouteDetailRecommendList?? && routeDetailGroup.prodRouteDetailRecommendList?size &gt; 0>
    <#assign routeDetailRecommend = routeDetailGroup.prodRouteDetailRecommendList[0] />
<#else>
    <#assign routeDetailRecommend = prodRouteDetailRecommendEmpty />
</#if>

 <#--推荐项目 START-->
    <div class="module template-recommend <#if newStructureFlag == "Y">state-view<#else>state-edit</#if>" data-id="${routeDetailGroup.groupId}">

        <div class="module-head clearfix">
            <div class="module-title"><#if routeDetailGroup?? && routeDetailGroup.moduleType == "RECOMMEND">推荐项目</#if></div>

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

        <!--推荐项目查看 START-->
        <div class="view">

            <div class="module-post clearfix">
            
                <#assign referencePrice = routeDetailFormat.getCnPriceFormat(routeDetailRecommend.referencePrice, routeDetailRecommend.currency, '')!'' />
                <div class="module-post-left">
                    <p>${routeDetailGroup.getTimeType()!''}</p>
                    <#if routeDetailGroup.localTimeFlag =="Y">
                         <p class="text-gray module-local-time">当地时间</p>
                    </#if>
                </div>

                <div class="module-post-right">
                    <div class="module-post-content">
                        <div class="view-content-new">
                            <div class="row">
                               <div class="col">
                                  <i class="icon-state icon-state-recommend"></i>
                               </div>
                               <div class="col mRight">
                                  <h3>
                                   <#if routeDetailRecommend.recommendName != ''>${routeDetailRecommend.recommendName!''}</#if>
                                  </h3>
                               </div>
                                <!--参考价格 -->
                                
                                <#if referencePrice != "">
                                <div class="col">
                                                                                                            参考价格：
                                </div>
                                <div class="col mRight">
                                    ${referencePrice!''}  
                                </div>
                                </#if>
                                <!--项目时间 -->
                                <#assign visitTime = routeDetailRecommend.visitTime/>
                                <#if visitTime != "">
                                <div class="col">
                                                                                                            项目时间：
                                </div>
                                <div class="col">
                                    ${visitTime!''}   分      钟
                                </div>
                                </#if>
                            </div>
                            <!--地址-->
                            <#if routeDetailRecommend.address != "">
                            <div class="row">
                                <div class="col w65">
                                                                                                                           地 &emsp;址：                                                                   
                                </div>
                                <div class="col row-inline-mr25">
                                    ${routeDetailRecommend.address?replace('\n','<br/>')}
                                </div>
                            </div>
                            </#if>
                            <!--说明-->
                            <#if routeDetailRecommend.recommendDesc != "">
                            <div class="row">
                                    ${routeDetailRecommend.recommendDesc?replace('\n','<br/>')}
                            </div>
                            <#else>
                            <div class="row">
                            <#if categoryId==15>特别说明：自费项目均是建议性项目，客人应本着“自愿自费”的原则酌情参加，如以上项目参加人数不足时，则可能无法成行或费用做相应调整。<#else>在行程游览过程中，导游可能会向您推荐如下自费项目，您可以根据您的自身情况，自愿选择参加自己喜欢的自费项目。</#if>
                            </div>
                            </#if>
                        </div>
                    </div>
                </div>

            </div>
        </div>
        <!--推荐项目查看 END-->

        <!--推荐项目编辑 START-->
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
                  <input type="hidden" name="categoryId" value="${categoryId}"/>
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
                <div class="module-main m-recommend">
                <div class="row pl10">
                	 <p>注：当前内容填写后将记录在合同条款推荐项目内</p>
                </div>

                 <#if routeDetailGroup.moduleType == "RECOMMEND">
                      <div class="row">
                           <div class="col module-label w70">
                                      <em>*</em>项目名称 ：
                           </div>
                           <div class="col">
                                <input type="text" class="form-control w730" placeholder="输入项目名称" data-validate="{required:true}" maxlength="100" name="prodRouteDetailRecommendList[0].recommendName" value="${routeDetailRecommend.recommendName!''}" />
                           </div>
                     </div>
                     <div class="row">
                           <div class="col module-label w70">
                                      <em>*</em>地  点 ：
                           </div>
                           <div class="col">
                                <input type="text" class="form-control w730" placeholder="输入地点" maxlength="100" data-validate="{required:true}" name="prodRouteDetailRecommendList[0].address" value="${routeDetailRecommend.address!''}" />
                           </div>
                     </div>
                     <div class="row">
                        <div class="col module-label w70">
                                      <em>*</em>参考价格：
                        </div>
                        <div class="col mRight">
                          <div class="JS_item_form_hidden" style="display:none">
                            <input type="hidden"class="hidden_recommend_price" name="prodRouteDetailRecommendList[0].referencePrice" value="${routeDetailRecommend.referencePrice!''}"/>
                          </div> 
                            <input type="text" class="form-control w140 JS_recommend_price" value="${routeDetailFormat.formatPrice(routeDetailRecommend.referencePrice)!''}" data-validate="{required:true,regular:true}" data-validate-regular="^\d{1,5}(\.\d{1,2})?$" maxlength="5"/>
                        </div>
                        <div class="col mRight">   
                            <select class="form-control w80" name="prodRouteDetailRecommendList[0].currency">
                                <#list currencys as currency>
                                    <option value="${currency.name()!''}" <#if currency.name()==routeDetailRecommend.currency>selected</#if> >${currency.cnName!''}</option>
                                </#list>
                            </select>
                        </div>
                        <div class="col">
                              <#if productType!="FOREIGNLINE" && categoryId!=18 ><em style='color:#FF0000'>*</em></#if>项目时间 ：
                        </div>
                        <div class="col">
                            <input type="text" class="form-control"  maxlength="5"
                              <#if productType!="FOREIGNLINE" && categoryId!=18 > data-validate="{required:true,regular:仅支持输入数字}"<#else>data-validate="{regular:仅支持输入数字}"</#if> data-validate-regular="^\d*$" name="prodRouteDetailRecommendList[0].visitTime" value="${routeDetailRecommend.visitTime}"/> 分钟
                        </div>
                    </div>
                 </#if>
           
                    <div class="row">
                        <div class="ol module-label w70"><#if categoryId==15><em>*</em></#if>项目说明：</div>
                        <div class="col JS_textares_box">
                            <a class="textarea-content-expand JS_textarea_expand">展开项目说明 <i class="triangle"></i></a>
                                 <textarea class="form-control textarea-content" <#if categoryId==15>data-validate="{required:true}"</#if> name="prodRouteDetailRecommendList[0].recommendDesc" value="${routeDetailRecommend.recommendDesc!''}"  maxlength="1000" ><#if (routeDetailRecommend?? && routeDetailRecommend.recommendDesc !="")>${routeDetailRecommend.recommendDesc!''}<#else><#if categoryId==15>特别说明：自费项目均是建议性项目，客人应本着“自愿自费”的原则酌情参加，如以上项目参加人数不足时，则可能无法成行或费用做相应调整。<#else>在行程游览过程中，导游可能会向您推荐如下自费项目，您可以根据您的自身情况，自愿选择参加自己喜欢的自费项目。</#if></#if></textarea>
                            <a class="textarea-content-shrink JS_textarea_shrink">收起项目说明 <i class="triangle"></i></a>
                        </div>
                    </div>
                </div>
                <!--模块右侧 END-->
            </div>
           </form>
        </div>
        <!--推荐项目编辑 END-->

        <div class="day-module-add" <#if newStructureFlag=='N'>style="display:none"</#if> >
            <div class="day-module-add-title">添加行程信息 <i class="triangle"></i></div>
        </div>

    </div>
    <#--推荐项目 END-->