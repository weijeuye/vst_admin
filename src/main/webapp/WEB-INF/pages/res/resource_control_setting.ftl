<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>资源预控设置</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/resource-control-settings.css"/>
    <style>
    .Pages {
        margin-top: 10px;
    }
    .PageLink {
        margin: 5px;
        padding:5px;!important
    }
    .PageSel {
        background-color: #eee;
        padding: 5px;
    }
    </style>
</head>
<body class="resource-control-settings">

<div class="everything">

    <h2 class="title">资源预控设置</h2>

    <!--筛选 开始-->
    <div class="filter">

        <form class="filter-form clearfix" action="/vst_admin/goods/recontrol/find/resPrecontrolPolicyList.do" id="findForm" method="post">

            <div class="col w750">
                <div class="row">

                    <div class="col w180">
                        <div class="form-group">
                            <label>
                                <span class="w60 inline-block">供应商名称</span><input name="supplierName" id="ProviderName" type="text" class="form-control search w90 JS_autocomplete_pn"  value="${supplierName}" data-validate="{required:true}"/>
                            </label>
                        </div>
                    </div>
                    <div class="col w180">
                        <div class="form-group">
                            <label>
                                <span class="w60 inline-block">预控名称</span><input name="name" class="form-control w90" type="text" value="${controlName}">
                            </label>
                        </div>
                    </div>
                    <div class="col w180">
                        <div class="form-group">
                            <label>
                                <span class="w60 inline-block">供应商ID</span><input id="supplierId" name="supplierId" class="form-control w90 JS_autocomplete_pn_id" type="text" value="${supplierId}">
                            </label>
                        </div>
                    </div>
                    <div class="col w180">
                        <div class="form-group">
                            <label>
                                <span  class="w60 inline-block">预控方式</span>
                                <select name="controlType" class="form-control w90">
                                        <option value="">不限</option>
                                    <#if controlType=="amount">
                                        <option value="amount" selected=selected>预控金额</option>
                                    <#else>
                                        <option value="amount">预控金额</option>
                                    </#if>
                                    <#if controlType=="inventory">
                                        <option value="inventory" selected=selected>预控库存</option>
                                    <#else>
                                        <option value="inventory">预控库存</option>
                                    </#if>
                                </select>
                            </label>
                        </div>
                    </div>

                </div><!-- end of first row -->

                <div class="row">
                    <div class="col w180">
                        <div class="form-group">
                            <label>
                                <span class="w60 inline-block">预控类型</span>
                                <select name="controlClassification" class="form-control w100">
                                        <option value="">全部</option>
                                    <#if controlClassification=="Daily">
                                        <option value="Daily" selected="selected">按日预控</option>
                                    <#else>
                                        <option value="Daily">按日预控</option>
                                    </#if>
                                    <#if controlClassification=="Cycle">
                                        <option value="Cycle" selected="selected">按周期预控</option>
                                    <#else>
                                        <option value="Cycle">按周期预控</option>
                                    </#if>
                                </select>
                            </label>
                        </div>
                    </div>
                    <div class="col w180">
                        <div class="form-group">
                            <label>
                                <span class="w60 inline-block">产品经理</span><input name="productManagerName" class="form-control search w90 JS_autocomplete_pm" type="text" value="${managerName}"><input name="productManagerId" type="hidden" class="JS_autocomplete_pm_hidden" id="ProductManagerId"/>
                            </label>
                        </div>
                    </div>
                    <div class="col w360">
                        <div class="form-group">
                            <label>
                                <span class="w60 inline-block">游玩日期</span>
                                    <#if trackformDate!=null>
                                        <input name="tradeEffectDate" class="form-control w90 mr10 JS_play_date" type="text" value="${trackformDate}">
                                    <#else>
                                        <input name="tradeEffectDate" class="form-control w90 mr10 JS_play_date" type="text" >
                                    </#if>
                                    <#if trackbackDate!=null>
                                        <input name="tradeExpiryDate" class="form-control w90 JS_play_date" type="text" value="${trackbackDate}">
                                    <#else>
                                        <input name="tradeExpiryDate" class="form-control w90 JS_play_date" type="text" value="" >
                                    </#if>
                            </label>
                        </div>
                    </div>
                    
                </div><!-- end of second row -->
                
                <div class="row">
                        <div class="col w180" >
                             <span class="w60 inline-block">预控状态</span>
                            <select name="state" class="form-control w100">
                                <option value="" selected="selected">全部</option>
                                <#if state == "New">
                                    <option value="New" selected>新建</option>
                                <#else>
                                    <option value="New">新建</option>
                                </#if>
                                <#if state == "InUse">
                                    <option value="InUse" selected>启用</option>
                                <#else>
                                    <option value="InUse">启用</option>
                                </#if>
                                <#if state == "Termination">
                                    <option value="Termination" selected>终止</option>
                                <#else>
                                    <option value="Termination">终止</option>
                                </#if>
                                <#if state == "Expired">
                                    <option value="Expired" selected>到期</option>
                                <#else>
                                    <option value="Expired">到期</option>
                                </#if>
                            </select>
                        </div>
                        <div class="col w180" >
                             <span class="w50 inline-block">所属BU</span>
                            <select name="buCode" class="form-control w100">
                                <option value="">请选择</option>
                                <option value="LOCAL_BU" <#if buCode == "LOCAL_BU">selected</#if> >国内游事业部</option>
                                <option value="OUTBOUND_BU" <#if buCode == "OUTBOUND_BU">selected</#if>>出境游事业部</option>
                                <option value="DESTINATION_BU" <#if buCode == "DESTINATION_BU">selected</#if>>目的地事业部</option>
                                <option value="TICKET_BU" <#if buCode == "TICKET_BU">selected</#if>>景区玩乐事业群</option>
                                <option value="BUSINESS_BU" <#if buCode == "BUSINESS_BU">selected</#if>>商旅定制事业部</option>
                            </select>
                        </div>
                        <div class="col w360" >
	                           <label>
	                               <span class="w60 inline-block">创建时间</span>
	                                   <#if creatTimeStart!=null>
	                                       <input name="creatTimeStart" class="form-control w90 mr10 JS_play_date" type="text" value="${creatTimeStart}">
	                                   <#else>
	                                       <input name="creatTimeStart" class="form-control w90 mr10 JS_play_date" type="text" >
	                                   </#if>
	                                   <#if creatTimeEnd!=null>
	                                       <input name="creatTimeEnd" class="form-control w90 JS_play_date" type="text" value="${creatTimeEnd}">
	                                   <#else>
	                                       <input name="creatTimeEnd" class="form-control w90 JS_play_date" type="text" value="" >
	                                   </#if>
	                           </label>
                        </div>
                    </div>
				
				<div class="row"> 
						<div class="col w180">
                        	<div class="form-group">
	                            <label>
	                                <span class="w60 inline-block">预控ID</span><input id="policyId" name="id" class="form-control w90 JS_autocomplete_id" type="text" value="${id}">
	                            </label>
                        	</div>
                    	</div>
                        <div class="col w180">
                            <div class="form-group">
                                <label>
                                    <span class="w60 inline-block">是否测试</span> 
                                    <input name="isTest" type="radio" value="Y" <#if isTest == 'Y'>checked="checked"</#if> />是
                                    &nbsp;&nbsp;<input name="isTest" type="radio" value="N"  <#if (isTest == 'N' || isTest == null || isTest == '')>checked="checked"</#if>/>否
                                </label>
                            </div>
                        </div>
					</div><!-- end of  row -->
            </div><!-- end of col w250 -->

            <div class="col w380">
                <div class="btn-group" style="margin-top: 50px;">
                    <a class="btn btn-primary" id="find">查询</a>
                    <!-- 预控策略在星云系统中维护 -->
                   <#-- <a class="btn JS_add_control">新增预控</a> -->
                    <a class="btn" id="export_button">导出</a>
                    <@mis.checkPerm permCode="5589" >
                         <a class="btn JS_pushHistoryOrder" id="pushHistoryOrder">历史数据补录</a>
                    </@mis.checkPerm>
                </div>
                <div class="btn-group" style="margin-top: 5px;">
                    <a class="btn btn-primary" id="batchImport">批量导入付款</a>
                    <a style="font-size: 12px;margin-top: 3px;" href="#" id="downloadPaymentTemplate">下载批量导入付款模板</a>
                </div>
            </div><!-- end of col w350 -->

        </form>
    </div>
    <!--筛选 结束-->

    <div class="resource-table">

        <table class="table table-border">
            <thead>
                <tr>
                	<th width="4%">预控ID</th>
                    <th width="12%">预控名称</th>
                    <th width="5%">供应商ID</th>
                    <th width="13%">供应商名称</th>
                    <th width="5%">产品经理</th>
                    <th width="4%">预控方式</th>
                    <th width="8%"><span class="text-success">库存</span>/<span class="text-danger">金额</span></th>
                    <th width="4%">预控类型</th>
                    <th width="4%">预控状态</th>
                    <th width="6%">子预控<span class="text-success">库存</span>/<span class="text-danger">金额</span></th>
                    <th width="10%">游玩起止日</th>
                    <th width="6%">所属BU</th>
                    <th width="2%">是否测试</th>
                    <th width="8%">创建时间</th>
                    <th width="4%">已付款金额</th>
                    <th width="18%">操作</th>
                </tr>
            </thead>

        <#if pageParam?? && pageParam.items?? && pageParam.items?size &gt; 0>
            <tbody>
                <#list pageParam.items  as rs>
                    <tr>
                    	<td>${rs.id}</td>
                        <td>${rs.name}</td>
                        <td>${rs.supplierId}</td>
                        <td>${rs.supplierName}</td>
                        <td>${rs.productManagerName}</td>
                        <td>
                            <#if rs.controlType == "amount">
                                                                金额</td>
                            <#else>
                                                                库存
                        </td>
                        </#if>
                        <td>
                            <#if rs.controlType == "amount">
                                <#if rs.controlClassification == "Daily">
                                    <span class="text-danger">￥${rs.amount}</span>
                                <#else>
                                    <span class="text-danger">￥${rs.leave}/￥${rs.amount}</span>
                                </#if>
                            <#else>
                                <#if rs.controlClassification == "Daily">
                                    <span class="text-success">${rs.amount}</span>
                                <#else>
                                    <span class="text-success">${rs.leave}/${rs.amount}</span>
                                </#if>
                            </#if>
                        </td>
                        <td>
                            <#if rs.controlClassification == "Daily">
                                                                            天</td>
                            <#else>
                                                                            周期</td>
                            </#if>
                        </td>
                        <td class="stateHtml">
                            <#if rs.state == "New">
                                <span class="text-info">新建</span>
                            <#elseif rs.state == "InUse">
                                <span class="text-success">启用</span>
                            <#elseif rs.state == "Termination">
                                <span class="text-danger">终止</span>
                            <#elseif rs.state == "Expired">
                                <span class="text-warning">到期</span>
                            <#else>
                                <span class="text-default">未定义</span>
                            </#if>
                        </td>
                        <td>
                            <#if rs.controlType == "amount">
                                <span class="text-danger">￥${rs.itemSumAmount}</span>
                            <#else>
                                <span class="text-success">${rs.itemSumAmount}</span>
                            </#if>
                        </td>
                        <td>${rs.tradeEffectDate?string("yyyy-MM-dd")} -${rs.tradeExpiryDate?string("yyyy-MM-dd")}</td>
                        <td>${rs.buCnName}</td>
                    	<td>
                            <#if rs.isTest == "Y">是
                            <#else>否
                        	</#if>
                    	</td>
                        <td>${rs.creatTime?string("yyyy-MM-dd HH:mm:ss")}</td>
                        <td>￥${rs.payAmountYuan}</td>
                        <td>
                            <input name='id' type="hidden" class="JS_control_id" value="${rs.id}"/>
                            <input name='TgsupplierId' type="hidden" class="TgsupplierId" value="${rs.supplierId}"/>
                             <input name='showLog' type="hidden" class="show_log" value="${rs.controlClassification}"/>
          
                             <@mis.checkPerm permCode="5578" >
                                <a class="mr5 JS_pay" data-param="${rs.id}">付款</a>
                             </@mis.checkPerm>
                            <#if rs.state == "New">
                               <!-- 在星云系统中维护 -->
                               <#-- <a class="mr5">更新</a>  
                                <a class="mr5 JS_edit_control">修改</a> -->
                                <a class="mr5 JS_edit_control">查看</a>
                                <a class="mr5 Binding">绑定</a>
                                <#if rs.controlClassification == "Daily">
                                    <a class="mr5 JS_view_remainder">查看剩余量</a>
                                </#if>
                                <a class="mr5 JS_show_log" data-param1="${rs.id}">操作日志</a>
                                <!-- 在星云系统中维护 -->
                                <#-- <a class="mr5 JS_delete_control" data-param="${rs.id}">删除</a> -->
                            <#elseif rs.state == "InUse">
                             	<!-- 在星云系统中维护 -->
                                <#-- <a class="mr5">更新</a>  
                                <a class="mr5 JS_edit_control">修改</a> -->
                                <a class="mr5 JS_edit_control">查看</a>
                                <a class="mr5 Binding">绑定</a>
                                <#if rs.controlClassification == "Daily">
                                    <a class="mr5 JS_view_remainder">查看剩余量</a>
                                </#if>
                                <a class="mr5 JS_show_log" data-param1="${rs.id}">操作日志</a>
                                <!-- 在星云系统中维护 -->
                                <#-- <a class="mr5 JS_termination" data-param1="${rs.id}">终止</a> -->
                            <#elseif rs.state == "Termination">
                                <#if rs.controlClassification == "Daily">
                                    <a class="mr5 JS_view_remainder">查看剩余量</a>
                                </#if>
                                <a class="mr5 JS_show_log" data-param1="${rs.id}">操作日志</a>
                                <!-- 在星云系统中维护 -->
                                <#-- <a class="mr5 JS_recover" data-param1="${rs.id}">恢复</a> -->
                            <#else>
                                ------
                            </#if>

                        </td>
                    </tr>
                </#list>
            </tbody>
        </#if>
        </table>

        <#if pageParam.items?size == 0>
            <div class="hint mb10">
                <span class="icon icon-big icon-info"></span>抱歉，查询暂无数据
            </div>
        </#if>

        <div class="page-box">
         	<#if pageParam.items?exists>
				<div class="paging">
				    ${pageParam.getPagination()}
				</div>
			</#if>
       </div>

   </div><!-- end of filter>

</div><!-- end of everything -->

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<!--<script src="http://pic.lvmama.com/js/backstage/v1/resource-control-settings.js"></script>-->
<script src="http://pic.lvmama.com/js/backstage/v1/resource-add-control.js"></script>
<script>
    //TODO 开发维护此处业务代码
    //日志详情页
    $("a.JS_show_log").live("click",function(){

        var param2=$(this).data("param1");    
        //var param="{'objectId':"+param2+",'objectType':'RES_PRECONTROL_POLICY_POLICY'}"
        var param='objectId='+param2+'&objectType=RES_PRECONTROL_POLICY_POLICY&sysName=VST';
        backstage.dialog({
            width: 890,
            height: 500,
            title: "日志详情页",
            iframe: true,
            url: "/lvmm_log/bizLog/showVersatileLogList?"+param
        });

    });

    $(".Binding").bind("click",function(){
        var $this = $(this);
        var $parent = $this.parents("td");
        var supplierId = $parent.find(".TgsupplierId").val();
        var controlId  = $parent.find(".JS_control_id").val();
        window.location.href = "/vst_admin/percontrol/suppGoods/index.do?supplierId="+supplierId+"&policyId="+controlId;
    });

    //查询
    $("#find").bind("click",function(){
    	var reg = new RegExp("^[0-9]*$");
     	var policyId=$("#policyId").val();
     	var supplierId=$("#supplierId").val();
     	
     	if(!reg.test(supplierId)){  
	        alert("供应商ID请输入数字!");  
	        return;
	    }  
	    if(!reg.test(policyId)){  
	        alert("预控ID请输入数字!");  
	        return;
	    }  
	   $("#findForm").submit();
	});
	
    //导出
	$("#export_button").bind("click",function(){
		var url = "/vst_admin/goods/recontrol/find/exportExcelData.do";
		$("#findForm").attr("action",url);
	  	$("#findForm").submit();
	  	
	  	var url = "/vst_admin/goods/recontrol/find/resPrecontrolPolicyList.do";
	  	$("#findForm").attr("action",url);
	});


    //下载批量导入付款模板
	$("#downloadPaymentTemplate").bind("click",function(){
		var url = "/vst_admin/goods/recontrol/downloadPaymentTemplate.do";
		var form = document.createElement("form");
		//form.target = "_blank";
		// 模版导出
		form.action = url;
		form.method = "post";
		document.body.appendChild(form);
		form.submit();
		document.body.removeChild(form);
		form = null;
		/* $("#findForm").attr("action",url);
	  	$("#findForm").submit(); */
	});

    //产品经理自动完成
    $(function () {
        backstage.autocomplete({
            "query": ".JS_autocomplete_pm",
            "fillData": fillData,
            "choice": choice,
            "clearData": clearData
        });
        function fillData(self) {
            var url = "/vst_admin/goods/recontrol/findMangement.do";
            var text = self.$input.val();
            self.loading();
            $.ajax({
                url: url,
                data: {name: text},
                dataType:"json",
                success: function (json) {
                    var $ul = self.$menu.find("ul");
                    $ul.empty();
                    for (var i = 0; i < json.length; i++) {
                        var $li = $('<li data-id="' + json[i].id + '">' + json[i].name + '</li>');
                        $ul.append($li)
                    }

                    self.loaded();
                }
            });

        }
         function choice(self, $li) {

            var id = $li.attr("data-id");
            var $hidden = self.$input.parent().find(".JS_autocomplete_pm_hidden");
            $hidden.val(id);

        }
        function clearData(self) {
            var $hidden = self.$input.parent().find(".JS_autocomplete_pm_hidden");
            $hidden.val("");
        }
    });

      //供应商名称自动完成
    $(function () {
        backstage.autocomplete({
            "query": ".JS_autocomplete_pn",
            "fillData": fillData,
            "choice": choice,
            "clearData": clearData
        });
        function fillData(self) {
            var url = "/vst_admin/goods/recontrol/findSuppSupplier.do";
            var text = self.$input.val();
            self.loading();
            $.ajax({
                url: url,
                data: {name: text},
                dataType:"json",
                success: function (json) {
                    var $ul = self.$menu.find("ul");
                    $ul.empty();
                    for (var i = 0; i < json.length; i++) {
                        var $li = $('<li data-value="'+ json[i].value+'" data-id="' + json[i].id + '">' + json[i].name + '</li>');
                        $ul.append($li)
                    }

                    self.loaded();
                }
            });
        }
        function choice(self, $li) {

            var id = $li.attr("data-id");
            var $id = $(".filter").find(".JS_autocomplete_pn_id");
            $id.val(id);

        }
        function clearData(self) {
            var $id = $(".filter").find(".JS_autocomplete_pn_id");
            $id.val("");
        }
    });

/*
    //新增预控
    $(function () {
        var $document = $(document);
        $document.on("click", ".JS_add_control", viewRemainderHanlder);
        function viewRemainderHanlder() {
            var $this = $(this);
            var url = "/vst_admin/goods/recontrol/goToAddResControl/view.do";
             window.dialogViewOrder = backstage.dialog({
                width: 820,
                height: 600,
                title: "新增预控",
                iframe: true,
                url: url
            });
        }
    });
*/
    //推送预控期订单
    $(function () {
        var $document = $(document);
        $document.on("click", ".JS_pushHistoryOrder", viewRemainderHanlder);
        function viewRemainderHanlder() {
            var $this = $(this);
            var url = "/vst_admin/percontrol/gotoPushHistoryOrder/view.do";
             window.dialogViewOrder = backstage.dialog({
                width: 1000,
                height: 500,
                title: "历史数据补录",
                iframe: true,
                url: url
            });
        }
    });
    

    //查看剩余量
    $(function () {

        var $document = $(document);

        $document.on("click", ".JS_view_remainder", viewRemainderHanlder);
        function viewRemainderHanlder() {
            var $this = $(this);
            var $this = $(this);
            var $parent = $this.parents("td");

            var controlId = $parent.find(".JS_control_id").val();
            var url ="/vst_admin/goods/recontrol/goToRemainder/view.do?id="+controlId;
            var dialogViewRemainder = backstage.dialog({
                width: 900,
                height: 450,
                title: "查看剩余量",
                iframe: true,
                url: url
            });
        }

    });
/*
      //修改
    $(function() {
        var $document = $(document);
        $document.on("click", ".JS_edit_control", editRemainderHanlder);
        function editRemainderHanlder() {

            var $this = $(this);
            var $parent = $this.parents("td");
            var controlId = $parent.find(".JS_control_id").val();

            console.log(controlId);

            var url = "/vst_admin/goods/recontrol/goToEditResPrecontrolPolicy/view.do?id="+controlId;
              window.dialogViewOrder = backstage.dialog({
                width: 820,
                height: 600,
                title: "修改预控",
                iframe: true,
                url: url
            });

        }
    });
*/     
      //查看
    $(function() {
        var $document = $(document);
        $document.on("click", ".JS_edit_control", editRemainderHanlder);
        function editRemainderHanlder() {

            var $this = $(this);
            var $parent = $this.parents("td");
            var controlId = $parent.find(".JS_control_id").val();

            console.log(controlId);

            var url = "/vst_admin/goods/recontrol/goToEditResPrecontrolPolicy/view.do?id="+controlId;
              window.dialogViewOrder = backstage.dialog({
                width: 820,
                height: 600,
                title: "查看预控",
                iframe: true,
                url: url
            });

        }
    }); 
    	//付款
        $(function() {
        	
	        //批量导入付款
	        $("#batchImport").on("click", function(){
	            var url = "/vst_admin/goods/recontrol/goToResControlPaymentBatchImport/view.do";
	              window.dialogViewresPorPayMent = backstage.dialog({
	                width: 700,
	                height: 150,
	                title: "批量导入付款",
	                iframe: true,
	                url: url
	            });
	        });
        	
	        var $document = $(document);
	        $document.on("click", ".JS_pay", editRemainderHanlder);
	        function editRemainderHanlder() {
	            var $this = $(this);
	            var $parent = $this.parents("td");
	            var id = $(this).attr("data-param");
	            console.log(id);
	            var url = "/vst_admin/goods/recontrol/goToResControlPaymentMain/view.do?precontrolPolicyId="+id;
	              window.dialogViewOrder = backstage.dialog({
	                width: 900,
	                height: 600,
	                title: "付款流水记录",
	                iframe: true,
	                url: url
	            });
	        }
	        
    	});
    
/*
    // 删除
    $(function() {
        $(".JS_delete_control").click(function() {
                
            var thisTd = $(this);
            var id = $(this).attr("data-param");
             var url = "/vst_admin/goods/recontrol/deleteResouceControl.do?id=" + id;
          backstage.confirm({
                    content: "确认删除吗？",
                    determineCallback: function () {
                        $.ajax({
                            url: url,
             				dataType:"json",
              				async : false,
                            success: function(callback) {
                             if (callback.code == 1){
                                backstage.alert({
                                    content:"删除成功"
                                });
                             thisTd.parent().parent().remove();
                             }else{
                              backstage.alert({
                                    content:"删除失败"
                                });
                             }
                            }
                           

                        })
                    }
                });
               

        });
    });
*/
/*
    // 终止
    $(function() {
        $(".JS_termination").live('click',function() {
            var $this = $(this);
            var id = $this.data("param1");
            var $parent = $this.parents("td");
            var showLog = $parent.find("showLog").val();
            var url = "/vst_admin/goods/recontrol/freezeResouceControl.do?id=" + id;
            
            backstage.confirm({
                content: "确认终止吗？",
                determineCallback: function() {
                    
                    $.ajax({
                        url: url,
                        dataType:"json",
                        async : false,
                        success: function (callback) {
                           // console.log(callback);
                            backstage.alert({content: callback.msg});
                            if(callback.code == 1) {
                                $this.parent().parent().children(".stateHtml").html("<span class='text-danger'>终止</span>");
                                var htmlString = "<input name='id' type='hidden' class='JS_control_id' value='" + id + "'/>";
                                if(showLog == 'Daily'){
                                  htmlString = htmlString + "<a class='mr5 JS_view_remainder'>查看剩余量</a>";
                                }
                                $this.parent().html(htmlString + "<a class='mr5 JS_show_log' data-param1='" + id + "'>操作日志</a>   <a class='mr5 JS_recover' data-param1='" + id + "'>恢复</a>");
                            }
                        }
                    });
                    
                }
            });

        });
    });
 */   
    
    
    
 /*   
     //恢复
 
        $(".JS_recover").live('click',function() {
            var thisTd = $(this);
            var id = $(this).data("param1");
            var $parent = thisTd.parents("td");
            var showLog = $parent.find("showLog").val();
            var url = "/vst_admin/goods/recontrol/recoverResouceControl.do?id=" + id;
            
            backstage.confirm({
                content: "确定要恢复吗？",
                determineCallback: function() {
                   $.ajax({
                        url: url,
                        dataType:"json",
                        async : false,
                        success: function (callback) {
                           // console.log(callback);
                            backstage.alert({content: callback.msg});
                            if(callback.code == 1) {
                                thisTd.parent().parent().children(".stateHtml").html("<span  class='text-success' >启用</span>");
                                var htmlString ="<a class='mr5'>更新</a>   <a class='mr5 JS_edit_control'>修改</a>  <a class='mr5 Binding'>绑定</a><input name='id' type='hidden' class='JS_control_id' value='" + id + "'/>";
                                if(showLog == 'Daily'){
                                htmlString = htmlString + "<a class='mr5 JS_view_remainder'>查看剩余量</a>" ;
                                }
                                thisTd.parent().html(htmlString+"<a class='mr5 JS_show_log' data-param1='" + id + "'>操作日志</a>   <a class='mr5 JS_termination' data-param1='"+id+"'>终止</a>");
                            }
                        }
                    });
                    
                }
            });

        });
*/
    

</script>
</body>
</html>
