<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>录入行程明细</title>
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"><#--宽度 缩放比例-->
    <link rel="shortcut icon" href="http://www.lvmama.com/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/base.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/travel-structuring/index.css">
</head>
<body>
<input type="hidden" id="noEditFlag" name="noEditFlag" value="${noEditFlag}">
<#--定义是否为新结构标记变量-->
<#assign newStructureFlag = (prodLineRoute?? && prodLineRoute.newStructureFlag == "N")?string("N","Y") />

<#--确定行程有多少天,routeNum和count(detail)中最大的一个 -->
<#if prodLineRoute.routeNum gte prodLineRoute.prodLineRouteDetailList?size>
    <#assign real_route_Num = prodLineRoute.routeNum>
<#else>
    <#assign real_route_Num = prodLineRoute.prodLineRouteDetailList?size>
</#if>

<#--如果是新行程结构还要取最大的nDay-->
<#if newStructureFlag=='Y'>
	<#list prodLineRoute.prodLineRouteDetailList as detail>
	    <#if real_route_Num lt detail.nDay>
	        <#assign real_route_Num = detail.nDay>
	    </#if>
	</#list>
</#if>
<#if productType ?? && productType == 'FOREIGNLINE'>
	<#if prodProduct??>
		<#if prodProduct.bizCategoryId==15
			|| prodProduct.bizCategoryId==16
			|| (prodProduct.bizCategoryId==18 && (prodProduct.subCategoryId=182 || prodProduct.subCategoryId=183|| prodProduct.subCategoryId=184))>
			<#assign flightTimeValidate = 'Y'>
		</#if>
	</#if>		
</#if>
<!--主体 START-->
<div class="main">

    <!--隐藏数据-->
    <input type="hidden" id="defaultDay" name="defaultDay" value="0"/>
    <#--产品品类-->
    <input type="hidden" id="productType" name="productType" value="${productType!''}"/>
    <input type="hidden" id="categoryId" name="categoryId" value="${categoryId!''}"/>
	<input type="hidden" id="flightTimeValidate" name="flightTimeValidate" value="${flightTimeValidate!''}"/>
    <!--顶部 START-->
    <div class="top">
        <div style="display:none;" id="prodLineRouteDiv">
            <!--ProdLineRoute结构相关的共享信息-->
            <input type='hidden' name='productId' value="${prodLineRoute.productId}"/>
            <input type='hidden' name='lineRouteId' value="${prodLineRoute.lineRouteId}"/>
            <input type='hidden' name='newStructureFlag' value="${newStructureFlag}"/>
            <input type='hidden' name='route_num' value="${prodLineRoute.routeNum}"/>
        </div>
        <!--导航 START-->
        <div class="navigation-prev"><i></i></div>
        <div class="navigation">
            <div class="navigation-list JS_days_tabs clearfix">
                <!-- 天导航-->
                <#list 1..real_route_Num as day_index>
                        <div class="navigation-item  <#if day_index == 1>active</#if>">
                            <a>
                                <em>第</em><b>${day_index}</b><em>天</em>
                            </a>
                    
                            <div class="box">
                                <div class="triangle"></div>
                            </div>
                        </div>
                </#list>
            </div>
        </div>
        <div class="navigation-next"><i></i></div>
        <div class="navigation-add"><i></i></div>
        <!--导航 END-->

        <div class="top-info">
        <#if noEditFlag == "true">
        	<a id="toEdit"  class="travel">编辑行程</a>
        </#if>
            <span class="travel">${prodLineRoute.routeName}</span>
            <a class="btn btn-primary btn-large top-control-save JS_all_save">保存</a>
        </div>

        <!--天下拉菜单 START-->
        <div class="navigation-control">
            <a class="JS_tab_insert_day">新增一天</a>
            <a class="JS_tab_delete_day">删除当天</a>
            <a class="JS_tab_move_prev">前移一天</a>
            <a class="JS_tab_move_next">后移一天</a>
        </div>
        <!--天下拉菜单 END-->

        <div class="top-bottom"></div>

        <div class="top-save-tip">
            请注意：当前行程天数与您所添加的天数表格数量不一致
            <div class="close"></div>
        </div>
    </div>
    <!--顶部 END-->
    <!--内容 START-->
    <#include "/dujia/comm/route/mainContent.ftl"/>
    <!--内容 END-->

    <div class="hint">
        <label>
            <input type="checkbox" class="JS_warning_flag" <#if (prodLineRoute?? && prodLineRoute.warningFlag == "Y")>checked="checked"</#if> />
           <!-- 以上行程时间安排可能会因天气、路况等原因做相应调整，敬请谅解 -->
            <input type="text" class="form-control w400 JS_warning_text"  value="<#if (prodLineRoute?? && prodLineRoute.warningText !="")>${prodLineRoute.warningText!''}<#else>以上行程时间安排可能会因天气、路况等原因做相应调整，敬请谅解</#if>" <#if (prodLineRoute?? && prodLineRoute.warningFlag != "Y")>disabled="disabled"</#if>  maxlength="100">
            
        </label>
    </div>

    <!--模块下拉菜单 START-->
    <ul class="day-module-add-content">
        <li class="day-module-add-content-traffic" data-template="template-traffic"><i class="icon-state icon-state-traffic-air"></i>交通</li>
        <li class="day-module-add-content-restaurant" data-template="template-restaurant"><i class="icon-state icon-state-restaurant"></i>用餐</li>
        <li class="day-module-add-content-hotel" data-template="template-hotel"><i class="icon-state icon-state-hotel"></i>住宿</li>
        <li class="day-module-add-content-view-spot" data-template="template-view-spot"><i class="icon-state icon-state-view-spot"></i>景点</li>
        <li class="day-module-add-content-free-time ml0" data-template="template-free-time"><i class="icon-state icon-state-activity"></i>自由活动</li>
        <li class="day-module-add-content-shop" data-template="template-shop"><i class="icon-state icon-state-shopping"></i>购物点</li>
        <li class="day-module-add-content-others" data-template="template-others"><i class="icon-state icon-state-traffic-other"></i>其他活动</li>
        <li class="day-module-add-content-recommend" data-template="template-recommend"><i class="icon-state icon-state-traffic-recommend"></i>推荐项目</li>
        <li class="triangle"></li>
    </ul>
    <!--模块下拉菜单 END-->

    <!--时间编辑器 START-->
    <div class="time-edit clearfix">
        <div class="time-edit-hour">
            <div class="row">
                <div class="col">00</div>
                <div class="col">01</div>
                <div class="col">02</div>
                <div class="col">03</div>
                <div class="col">04</div>
                <div class="col">05</div>
            </div>
            <div class="row">
                <div class="col">06</div>
                <div class="col">07</div>
                <div class="col">08</div>
                <div class="col">09</div>
                <div class="col">10</div>
                <div class="col">11</div>
            </div>
            <div class="row">
                <div class="col">12</div>
                <div class="col">13</div>
                <div class="col">14</div>
                <div class="col">15</div>
                <div class="col">16</div>
                <div class="col">17</div>
            </div>
            <div class="row">
                <div class="col">18</div>
                <div class="col">19</div>
                <div class="col">20</div>
                <div class="col">21</div>
                <div class="col">22</div>
                <div class="col">23</div>
            </div>
            <div class="row fragment">
                <div class="col">早上</div>
                <div class="col">上午</div>
                <div class="col">中午</div>
                <div class="col">下午</div>
                <div class="col">晚上</div>
            </div>
            <div class="row fragment mt0">
                <div class="col">早餐前</div>
                <div class="col">早餐后</div>
                <div class="col">中餐后</div>
                <div class="col">晚餐后</div>
                <div class="col">全天</div>
            </div>
        </div>
        <div class="time-edit-blank">:</div>
        <div class="time-edit-minute">
            <div class="row">
                <div class="col">00</div>
                <div class="col">05</div>
            </div>
            <div class="row">
                <div class="col">10</div>
                <div class="col">15</div>
            </div>
            <div class="row">
                <div class="col">20</div>
                <div class="col">25</div>
            </div>
            <div class="row">
                <div class="col">30</div>
                <div class="col">35</div>
            </div>
            <div class="row">
                <div class="col">40</div>
                <div class="col">45</div>
            </div>
            <div class="row">
                <div class="col">50</div>
                <div class="col">55</div>
            </div>
        </div>
    </div>
    <!--时间编辑器 END-->

</div>
<!--主体 END-->

<!--浮动框 START-->
<div class="float-flow">
    <a class="now-edit">当前编辑</a>
</div>
<!--浮动框 END-->

<!--模板 START-->
<div class="template">

    <!--天标签 START-->
    <div class="navigation-item">
        <a>
            <em>第</em><b>1</b><em>天</em>
        </a>

        <div class="box">
            <div class="triangle"></div>
        </div>
    </div>
    <!--天标签 END-->

    <!--天内容模板 START-->
    <div class="day">

        <!--一天 头部 START-->
        <div class="day-head clearfix">
            <div class="day-caption">
                第<b>1</b>天
            </div>
            <div class="day-head-form">

                <div class="launch">
                    <a class="JS_day_start">点击添加当天行程目的地或标题</a>
                </div>
                <div class="view">
                    标题内容
                </div>
                <div class="edit state-location">
                    <input type='hidden' name='detailId'  />
                    <input type='hidden' name='nDay'  />
                    <select class="form-control day-head-switch JS_switch_title mr10">
                        <option value="LOCATION">使用目的地</option>
                        <option value="TITLE">使用标题</option>
                    </select>
                    <!--使用目的地 START-->
                    <span class="location">
                        <span class="location-list">
                            <span class="location-item">
                                <input class="form-control w60" type="text" placeholder="输入地点"
                                       data-validate="{required:true}" maxlength="20"/>
                            </span>
                            <span class="location-item">
                                -
                                <input class="form-control w60" type="text" placeholder="输入地点"
                                       maxlength="20"/>
                                <div class="location_del JS_location_del">删除</div>
                            </span>
                        </span>
                        <a class="location-add JS_location_add">增加目的地</a>
                    </span>
                    <!--使用目的地 END-->

                    <!--使用标题 START-->
                    <span class="title">
                        <input class="form-control w180" type="text" placeholder="输入标题内容"
                               data-validate="{required:true}" maxlength="50" disabled="disabled"/>
                    </span>
                    <!--使用标题 END-->
                </div>

            </div>
            <div class="day-head-control">
                <a class="JS_day_delete">删除</a>
                <a class="link-edit JS_day_edit">编辑</a>
                <a class="btn btn-save JS_day_save">保存</a>
            </div>

            <div class="day-module-add">
                <div class="day-module-add-title">添加行程信息 <i class="triangle"></i></div>
            </div>
        </div>
        <!--一天 头部 END-->

        <!--一天 主体 START-->
        <div class="day-body"></div>
        <!--一天 主体 END-->

        <!--一天 底部 START-->
        <div class="day-foot clearfix">

            <p class="day-foot-btn-group">
                <a class="JS_content_del_day">删除当天</a>
                <a class="JS_content_add_day">新增一天</a>
            </p>

        </div>
        <!--一天 底部 END-->

        <!--添加一天高亮 START-->
        <div class="day-add-high-light"></div>
        <!--添加一天高亮 END-->

    </div>
    <!--天内容模板 END-->

    <!--目的地 START-->
    <span class="location-item">
        -
        <input class="form-control w60" type="text" placeholder="输入地点" maxlength="20"/>
        <div class="location_del JS_location_del">删除</div>
    </span>
    <!--目的地 END-->

    <#-- 引入酒店模板-->
    <#include "/dujia/comm/route/hotelTemplate.ftl"/>

    <#-- 引入景点模板-->
    <#include "/dujia/comm/route/scenicTemplate.ftl"/>

    <#-- 引入购物模板-->
    <#include "/dujia/comm/route/shoppingTemplate.ftl"/>

    <#-- 引入用餐模板-->
    <#include "/dujia/comm/route/mealTemplate.ftl"/>

    <#-- 引入交通模板-->
    <#include "/dujia/comm/route/vehicleTemplate.ftl"/>

    <#-- 引入活动模板-->
    <#include "/dujia/comm/route/activityTemplate.ftl"/>
    
    <#-- 引入推荐项目模板-->
    <#include "/dujia/comm/route/recommendTemplate.ftl"/>

</div>
<!--模板 END-->

<!--公用脚本 START-->
<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.2.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common/dialog.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common/float-alert.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common/validate.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common/autocomplete.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common/poptip.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common/multiple-select.js"></script>
<!--公用脚本 END-->
<!--脚本 START-->
<!--<script src="http://pic.lvmama.com/js/backstage/v1/vst/travel-structuring/index.js"></script>-->
<!--引入页面前端逻辑JS-->
<script type="text/javascript" src="/vst_admin/js/dujia/comm/travel-structuring.js"></script>
<!--引入页面业务逻辑JS-->
<script type="text/javascript" src="/vst_admin/js/dujia/comm/travel-structuring-local.js"></script>
<script>
	$(function () {
		//页面关联则不可修改
	     $(document).ready(function (){
	         var $document = $(document);
		     if($("#noEditFlag").val() == "true"){
		       	$("input[type='radio']").attr("disabled",true);
		       	$("input[type='checkbox']").attr("disabled",true);
		       	$("input").attr("readonly",true);
		       	$("select").attr("disabled",true);
		       	$("textarea").attr("disabled",true);
		       	$document.unbind("click");
		//     	$("#toEdit").attr('href',''); 
	       		$("#toEdit").click(function () {
          			window.open('/vst_admin/dujia/comm/route/detail/showRouteDetail.do?routeId=${routeId}');
      		  });
	       	}
	    });
	});
</script>
</body>
</html>