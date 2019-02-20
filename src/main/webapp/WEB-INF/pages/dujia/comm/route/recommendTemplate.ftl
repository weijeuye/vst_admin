<#--推荐项目 START-->
<div class="module template-recommend">

    <div class="module-head clearfix">
        <div class="module-title">推荐项目</div>

        <div class="module-control">
        	<a class="JS_module_prev">上移</a>
            <a class="JS_module_next">下移</a>
            <a class="JS_module_delete">删除</a>
            <a class="module-btn-edit JS_module_edit">编辑</a>
            <a class="btn btn-save JS_module_save">保存</a>
        </div>
    </div>

    <!--推荐项目编辑 START-->
    <div class="edit">
    <form>
        <#-- 组隐藏域DIV -->
        <div class="JS_group_form_hidden">
            <input type="hidden" name="routeId" />
            <input type="hidden" name="detailId" />
            <input type="hidden" name="startTime" />
            <input type="hidden" name="moduleType" value = "RECOMMEND"/>
            <input type="hidden" name="sortValue" />
            <input type='hidden' name='productId' value="${prodLineRoute.productId}"/>
            <input type="hidden" name="categoryId" value="${categoryId}"/>
        </div>

        <div class="clearfix">
            <!--模块左侧 START-->
            <div class="module-side">
                <div class="row">
                    <div class="col module-label w70"><em>*</em>时间：</div>
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

                <div class="JS_item_form_hidden" style="display:none">
	                     <#-- 参考价格 -->
	                     <input type="hidden" class="hidden_recommend_price" name="prodRouteDetailRecommendList[0].referencePrice"/>
	            </div>
                <div class="row pl10">
                	 <p>注：当前内容填写后将记录在合同条款推荐项目内</p>
                </div>
       
       
                
                
               

               <div class="row JS_title_row">
                        <div class="col module-label w70">
                                <em>*</em>项目名称 ：
                        </div>
                        <div class="col">
                            <input type="text" class="form-control w730" placeholder="输入项目名称" maxlength="100" data-validate="{required:true,}" name="prodRouteDetailRecommendList[0].recommendName"/>
                        </div>
               </div> 
               
                   
               <div class="row JS_title_row">   
                         <div class="col module-label w70">
                                <em>*</em>地	点 ：
                        </div>
                        <div class="col">
                            <input type="text" class="form-control w730" placeholder="输入地点" maxlength="100" data-validate="{required:true,}" name="prodRouteDetailRecommendList[0].address"/>
                        </div>
               </div> 
               
                        
               <div class="row JS_title_row">
                    <div class="col module-label w70">
                        <em>*</em>参考价格：
                    </div>
                    <div class="col mRight">
                        <input type="text" class="form-control w140 JS_recommend_price"  data-validate="{required:true,regular:true}"
                               data-validate-regular="^\d{1,5}(\.\d{1,2})?$" maxlength="5"/>
                    </div>   
                    <div class="col mRight">        
                        <select class="form-control w80" name="prodRouteDetailRecommendList[0].currency">
                            <#list currencys as currency>
		                        <option value="${currency.name()!''}">${currency.cnName!''}</option>
		                    </#list>
                        </select>
                    </div>
                    <div class="col require_time">
                                项目时间 ：
                    </div>
                    <div class="col">
                            <input type="text" class="form-control" data-validate="{regular:仅支持输入数字}" maxlength="5" data-validate-regular="^\d*$" name="prodRouteDetailRecommendList[0].visitTime"/> 分钟
                    </div>
               </div>
                
 
                <div class="row">
                    <div class="col module-label w70"><#if categoryId==15><em>*</em></#if>项目说明：</div>
                    <div class="col JS_textares_box">
                        <a class="textarea-content-expand JS_textarea_expand">展开项目说明 <i class="triangle"></i></a>
                        <textarea class="form-control textarea-content"  <#if categoryId==15>data-validate="{required:true}"</#if> maxlength="1000" name="prodRouteDetailRecommendList[0].recommendDesc"><#if categoryId==15>特别说明：自费项目均是建议性项目，客人应本着“自愿自费”的原则酌情参加，如以上项目参加人数不足时，则可能无法成行或费用做相应调整。<#else>在行程游览过程中，导游可能会向您推荐如下自费项目，您可以根据您的自身情况，自愿选择参加自己喜欢的自费项目。</#if></textarea>
                        <a class="textarea-content-shrink JS_textarea_shrink">收起项目说明 <i class="triangle"></i></a>
                    </div>
                </div>
            </div>
            <!--模块右侧 END-->
        </div>

   </form>   
</div>
    <!--推荐项目编辑 END-->

    <div class="day-module-add">
        <div class="day-module-add-title">添加行程信息 <i class="triangle"></i></div>
    </div>

</div>
<#--推荐项目 END-->