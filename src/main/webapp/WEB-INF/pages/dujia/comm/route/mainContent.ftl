    <!--内容 START-->
    <div class="container JS_days_contents">
    	<#assign exist_day_index = 0>
    	<#list 1..real_route_Num as day_index>
    		<#if newStructureFlag=='Y'>
	    		<#if prodLineRoute.prodLineRouteDetailList?size gt exist_day_index>
	    			<#assign routeDetail = prodLineRoute.prodLineRouteDetailList[exist_day_index] >
	    			<#if day_index != routeDetail.nDay>
	    				<#assign routeDetail = ''>
	    			<#else>
	    				<#assign exist_day_index = exist_day_index + 1>
	    			</#if>
	    		<#else>
	    			<#assign routeDetail = ''>
	    		</#if>
    		<#else>
    			<#if prodLineRoute.prodLineRouteDetailList?size lt day_index>
    				<#assign routeDetail = ''>
	    		<#else>
	    			<#assign routeDetail = prodLineRoute.prodLineRouteDetailList[day_index-1] >
	    		</#if>
    		</#if>

    		<#--添加detailId属性便于查找-->
		    <!--天内容模板 START-->
		    <div class="day" <#if routeDetail == ''>detailId = ""<#else>detailId = "${routeDetail.detailId!''}"</#if>  >
				<#--老结构进入编辑，新结构且有数据进入预览-->
		        <#if prodLineRoute.newStructureFlag == 'Y' && routeDetail != ''>
		        	<#assign current_state = 'state-view'/>
		        <#elseif prodLineRoute.newStructureFlag == 'N'>
		        	<#assign current_state = 'state-edit'/>
		        <#else>
		        	<#assign current_state = ''/>
		        </#if>
		        <!--一天 头部 START-->
		        <div class="day-head clearfix ${current_state} "  >
		            <div class="day-caption">
		               	 第<b>${day_index}</b>天
		            </div>
		            <div class="day-head-form">
		
		                <div class="launch">
		                    <a class="JS_day_start">点击添加当天行程目的地或标题</a>
		                </div>
		                <div class="view">
		                    	<#if routeDetail!=''  && routeDetail.title??>${routeDetail.title}</#if>
		                </div>
		                
		                <#assign location_model = !(routeDetail!=''  && routeDetail.title?? && !routeDetail.title?contains("—")) />
		                <div class="edit <#if location_model==true>state-location <#else>state-title</#if> ">
		                	<input type='hidden' name='detailId' <#if routeDetail!=''>value="${routeDetail.detailId}"</#if>  />
		                    <input type='hidden' name='nDay' value="${day_index}"   />
		
		                    <select class="form-control day-head-switch JS_switch_title mr10">
		                        <option value="LOCATION" <#if location_model = true>selected</#if>  >使用目的地</option>
		                        <option value="TITLE"   <#if location_model = false>selected</#if> >使用标题</option>
		                    </select>
		                    <!--使用目的地 START-->
		                    <span class="location">
		                        <span class="location-list">
		                            <#if location_model == true>
		                            	<#if routeDetail != '' && routeDetail.title??>
		                               		<#assign routeDetailTitle = routeDetail.title?split("—")/>
		                               	<#else>
		                               		<#assign routeDetailTitle = ['','']/>
		                               </#if>
		                               <#list routeDetailTitle as location>
		                               		<#if location_index == 0 >
						                       <span class="location-item">
					                                <input class="form-control w60" type="text" placeholder="输入地点"
					                                       data-validate="{required:true}" maxlength="20" value="${location!''}" />
					                            </span>
				                            <#else>
					                            <span class="location-item">
					                                -
					                                <input class="form-control w60" type="text" placeholder="输入地点"
					                                       maxlength="20" value="${location!''}" />
					                                <div class="location_del JS_location_del">删除</div>
					                            </span>
				                            </#if>
			                            </#list>
			                        <#else>
			                        	<span class="location-item">
			                                <input class="form-control w60" type="text" placeholder="输入地点"
			                                       data-validate="{required:true}" maxlength="20" <#if location_model!= true>disabled</#if> />
			                            </span>
	                        			<span class="location-item">
	                        			 	-
			                                <input class="form-control w60" type="text" placeholder="输入地点"
			                                       data-validate="{required:true}" maxlength="20"  <#if location_model!= true>disabled</#if>/>
			                            </span>
		                            </#if>
		                        </span>
		                        <a class="location-add JS_location_add">增加目的地</a>
		                    </span>
		                    <!--使用目的地 END-->
		
		                    <!--使用标题 START-->
		                    <span class="title">
		                        <input class="form-control w180" type="text" placeholder="输入标题内容"
		                               data-validate="{required:true}" maxlength="50" 
		                               <#if location_model== false && routeDetail!=''  && routeDetail.title??>value="${routeDetail.title}"</#if>
		                               <#if location_model== true>disabled=""</#if>
		                               />
		                    </span>
		                    <!--使用标题 END-->
		                </div>
		
		            </div>
		            <#if prodLineRoute.newStructureFlag == 'Y'>
			            <div class="day-head-control">
			                <a class="JS_day_delete">删除</a>
			                <a class="<#if routeDetail == ''>link-edit</#if> JS_day_edit">编辑</a>
			                <a class="btn btn-save JS_day_save">保存</a>
			            </div>

			            <div class="day-module-add" <#if routeDetail!=''> style="display:block;"</#if>  >
			                <div class="day-module-add-title">添加行程信息 <i class="triangle"></i></div>
			            </div>
		            </#if>
		        </div>
		        <!--一天 头部 END-->
		
		        <!--一天 主体 START-->
		        <div class="day-body">
		        	<#if routeDetail!='' && routeDetail.prodRouteDetailGroupList??>
			        	<#list routeDetail.prodRouteDetailGroupList as routeDetailGroup>
			        		<#if routeDetailGroup.moduleType == 'FREE_ACTIVITY'>
			        			<#include "/dujia/comm/route/activity.ftl"/>
			        		<#elseif routeDetailGroup.moduleType == 'OTHER_ACTIVITY'>
			        			<#include "/dujia/comm/route/activity.ftl"/>
			        		<#elseif routeDetailGroup.moduleType == 'SCENIC'>
			        			<#include "/dujia/comm/route/scenic.ftl"/>
			        		<#elseif routeDetailGroup.moduleType == 'VEHICLE'>
			        			<#include "/dujia/comm/route/vehicle.ftl"/>
			        		<#elseif routeDetailGroup.moduleType == 'MEAL'>
			        			<#include "/dujia/comm/route/meal.ftl"/>
		        			<#elseif routeDetailGroup.moduleType == 'HOTEL'>
		        				<#include "/dujia/comm/route/hotel.ftl"/>
			        		<#elseif routeDetailGroup.moduleType == 'SHOPPING'>
			        			<#include "/dujia/comm/route/shopping.ftl"/>
			        		<#elseif routeDetailGroup.moduleType == 'RECOMMEND'>
			        			<#include "/dujia/comm/route/recommend.ftl"/>
			        		</#if>
			        	</#list>
		        	</#if>
		        </div>
		        <!--一天 主体 END-->
		
		        <!--一天 底部 START-->
		        <div class="day-foot clearfix">
		
		            <p class="day-foot-btn-group">
		                <a class="text-danger JS_content_del_day">删除当天</a>
		                <a class="JS_content_add_day">新增一天</a>
		            </p>
		
		        </div>
		        <!--一天 底部 END-->
		
		        <!--添加一天高亮 START-->
		        <div class="day-add-high-light"></div>
		        <!--添加一天高亮 END-->
		
		    </div>
		    <!--天内容模板 END-->
		</#list>
    </div>
    <!--内容 END-->