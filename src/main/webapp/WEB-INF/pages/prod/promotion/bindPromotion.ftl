<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>绑定产品</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link href="http://pic.lvmama.com/styles/backstage/v1/vst/base.css" rel="stylesheet">
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/active.css"/>
</head>
<body class="active">
     <div class="baseInformation" style="height: 700px">
        <div class="tab-box main" style="padding: 0px 4px 18px">
            <div class="clearfix">
                <ul class="nav-tabs header-left">
                    <li>当前已绑定产品</li>
                    <#if desc.cancelFlag?? && desc.cancelFlag=='N'>
                    	<li>绑定其他产品</li>
                    </#if>
                </ul>
            </div>
            <div class="tab-content">
             	<form id="searchForm" action="/vst_admin/prod/promotion/desc/queryBindpro.do" method="post">
	                <div class="fuzzy clearfix">
	                    <div class="row clearfix">
	                        <div class="col w380">
	                            <label>
	                                <span class="w80 inline-block">产品名称：</span>
	                                <div class="form-group inline-block">
	                                    <input id="ProduceName" placeholder="模糊查询" type="text"
	                                           class="form-control search w275 JS_autocomplete_pn" data-descId="${descId!''}"
	                                           data-validate="{required:true}" />
	                                    <input type="hidden" class="JS_autocomplete_pn_hidden" id="ProduceNameId"
	                                           name="productId"/>
	                                </div>
	                                <!--<input class="form-control w275" type="text" placeholder="模糊查询"/>-->
	                            </label>
	                        </div>
	                        <div class="col w165">
	                            <label>
	                                <span class="w80 inline-block">产品品类：</span>
	                                <select class="form-control w80" name="bizCategoryId">
	                               		<option value="">全部</option>
					                    <#list bizCategoryList as list>
							                <option value="${list.categoryId!''}">${list.categoryName!''}</option>
					                    </div>
								        </#list>
	                                </select>
	                            </label>
	                        </div>
	                    </div>
	                    <div class="row clearfix">
	                        <div class="col w525">
	                            <label>
	                                <span class="w80 inline-block">产品ID：</span>
	                                <input class="form-control w430" id="productIds" name="productIds" type="text" placeholder="可输入多个ID进行搜索，ID间以“，”隔开"/>
	                            </label>
	                        </div>
	                    </div>
	                    <a class="btn btn-primary boundCheck" id="search_button" data-descId="${descId!''}">查询</a>
	                </div>
                </form>
                <div id="resultBind" class="iframe_content mt20"></div>
            </div>
            <div class="tab-content">
	             <form id="searchForm1" action="/vst_admin/prod/promotion/desc/queryOtherpro.do" method="post">
	                <div class="fuzzy clearfix">
	                    <div class="row clearfix">
	                        <div class="col w255">
	                            <label>
	                                <span class="w75 inline-block">产品名称：</span>
	                                <div class="form-group inline-block">
	                                    <input id="ProduceName1"  type="text"
	                                           class="form-control search w165 JS_autocomplete_pn1"
	                                           data-validate="{required:true}" />
	                                    <input type="hidden" class="JS_autocomplete_pn1_hidden" id="ProduceName1Id"
	                                           name="productId"/>
	                                </div>
	                                <!--<input class="form-control w165" type="text"/>-->
	                            </label>
	                        </div>
	                        <div class="col w165">
	                            <label>
	                                <span class="w80 inline-block">产品品类：</span>
	                                <select class="form-control w80" name="bizCategoryId">
	                                    <option value="">全部</option>
					                    <#list bizCategoryList as list>
							                <option value="${list.categoryId!''}">${list.categoryName!''}</option>
					                    </div>
								        </#list>
	                                </select>
	                            </label>
	                        </div>
	                        <div class="col w155">
	                            <label>
	                                <span class="w80 inline-block">是否有效：</span>
	                                <select class="form-control w70" name="cancelFlag">
	                                    <option value="">不限</option>
	                                    <option value="Y">有效</option>
	                                    <option value="N">无效</option>
	                                </select>
	                            </label>
	                        </div>
	                        <div class="col w155">
	                            <label>
	                                <span class="w80 inline-block">是否可售：</span>
	                                <select class="form-control w70" name="saleFlag">
	                                    <option value="">不限</option>
	                                    <option value="Y">是</option>
	                                    <option value="N">否</option>
	                                </select>
	                            </label>
	                        </div>
	                    </div>
	                    <div class="row clearfix">
	                        <div class="col w260">
	                            <label>
	                                <span class="w75 inline-block">产品ID：</span>
	                                <input class="form-control w170" id="productIds1" name="productIds" type="text" placeholder="可输入多个ID进行搜索，ID间以“，”隔开"/>
	                            </label>
	                        </div>
	                        <div class="col w160">
	                            <label>
	                                <span class="w70 inline-block">产品经理：</span>
	                                <div class="form-group inline-block">
	                                    <input id="productManager" type="text"
	                                           class="form-control search w70 JS_autocomplete_pm"
	                                           data-validate="{required:true}" />
	                                    <input type="hidden" class="JS_autocomplete_pm_hidden" id="productManagerId"
	                                           name="managerId"/>
	                                    <!--<input type="hidden" class="JS_autocomplete_f_hidden_email" id="FounderEmail"-->
	                                    <!--name="FounderEmail"/>-->
	                                </div>
	                            </label>
	                        </div>
	                        <div class="col w170">
	                            <label>
	                                <span class="w80 inline-block">供应商名称：</span>
	                                <div class="form-group inline-block">
	                                    <input id="supplierName" type="text"
	                                           class="form-control search w70 JS_autocomplete_s"
	                                           data-validate="{required:true}" />
	                                    <input type="hidden" class="JS_autocomplete_s_hidden" id="supplierNameId"
	                                           name="supplierId"/>
	                                    <!--<input type="hidden" class="JS_autocomplete_f_hidden_email" id="FounderEmail"-->
	                                    <!--name="FounderEmail"/>-->
	                                </div>
	                            </label>
	                        </div>
	                        <div class="col w155">
	                            <label>
	                                <span class="w65 inline-block">所属公司：</span>
	                                <select class="form-control w70" name="subCompany">
	                                    <option value="">不限</option>
	                                    <#list filialeNameList as filiale>
			                    			<option value="${filiale.code}" <#if subCompany?? && subCompany==filiale.code>selected=selected </#if>  >${filiale.cnName}</option>
			                    		</#list>
	                                </select>
	                            </label>
	                        </div>
	                    </div>
	                    <a class="btn btn-primary boundCheck" id="search_button1" data-descId="${descId!''}">查询</a>
	                </div>
	              </form> 
                <div id="resultUnBind" class="iframe_content mt20"></div>
            </div>
        </div>
    </div>

<!--页面结束-->
<!--脚本模板开始-->

<div class="template">
    <!--绑定成功-->
    <div class="dialog-boundSuccess">
        <iframe src="about:blank" class="iframe-boundSuccess" frameborder="0"></iframe>
    </div>
</div>


<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/vst/activity-management/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/vst/activity-management/active.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/common/dialog.js"></script>
<script type="text/javascript">
	var oldTitle = window.parent.$(".dialog-header").text();
	oldTitle = oldTitle.substring(0,4);
	window.parent.$(".dialog-header").text(oldTitle+",绑定产品---活动ID："+"${desc.descId}"+"，活动名称："+"${desc.descName}");
    $(function(){
        //产品经理自动完成
        $(function () {
            backstage.autocomplete({
                "query": ".JS_autocomplete_pm",
                "fillData": fillData,
                "choice": choice,
                "clearData": clearData
            });
            function fillData(self) {
            	var productManager = $("#productManager").val();
                var url = "/vst_admin/pet/permUser/searchUser.do?search="+productManager;
                self.loading();
                $.ajax({
                    url: url,
                    success: function (json) {
                        var $ul = self.$menu.find("ul");
                        $ul.empty();
                        for (var i = 0; i < json.length; i++) {
                            var $li = $('<li  data-id="' + json[i].id + '">' + json[i].text + '</li>');
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
        //供应商自动完成
        $(function () {
            backstage.autocomplete({
                "query": ".JS_autocomplete_s",
                "fillData": fillData,
                "choice": choice,
                "clearData": clearData
            });
            function fillData(self) {
           		var supplierName = $("#supplierName").val();
                var url = "/vst_back/supp/supplier/searchSupplierList.do?search="+supplierName;
                self.loading();
                $.ajax({
                    url: url,
                    success: function (json) {
                        var $ul = self.$menu.find("ul");
                        $ul.empty();
                        for (var i = 0; i < json.length; i++) {
                            var $li = $('<li  data-id="' + json[i].id + '">' + json[i].text + '</li>');
                            $ul.append($li)
                        }

                        self.loaded();
                    }
                });
            }

            function choice(self, $li) {
                var id = $li.attr("data-id");
                var $hidden = self.$input.parent().find(".JS_autocomplete_s_hidden");
                $hidden.val(id);

            }
            function clearData(self) {
                var $hidden = self.$input.parent().find(".JS_autocomplete_s_hidden");
                $hidden.val("");
            }
        });
        //模糊查询--产品名称自动完成
        $(function () {
            backstage.autocomplete({
                "query": ".JS_autocomplete_pn",
                "fillData": fillData,
                "choice": choice,
                "clearData": clearData
            });
            function fillData(self) {
           		var productName = $("#ProduceName").val();
           		var descId = $("#ProduceName").attr("data-descId");
                var url = "/vst_admin/prod/promotion/desc/queryProName.do?descId="+descId+"&productName="+productName;
                self.loading();
                $.ajax({
                    url: url,
                    success: function (json) {
                        var $ul = self.$menu.find("ul");
                        $ul.empty();
                        for (var i = 0; i < json.length; i++) {
                            var $li = $('<li  data-id="' + json[i].productId + '">' + json[i].productName + '</li>');
                            $ul.append($li)
                        }

                        self.loaded();
                    }
                });
            }

            function choice(self, $li) {
                var id = $li.attr("data-id");
                var $hidden = self.$input.parent().find(".JS_autocomplete_pn_hidden");
                $hidden.val(id);

            }
            function clearData(self) {
                var $hidden = self.$input.parent().find(".JS_autocomplete_pn_hidden");
                $hidden.val("");
            }
        });
        //绑定其他产品--产品名称自动完成
        $(function () {
            backstage.autocomplete({
                "query": ".JS_autocomplete_pn1",
                "fillData": fillData,
                "choice": choice,
                "clearData": clearData
            });
            function fillData(self) {
           	 	var productName = $("#ProduceName1").val();
                var url = "/vst_admin/prod/promotion/desc/queryProName.do?&productName="+productName;
                self.loading();
                $.ajax({
                    url: url,
                    success: function (json) {
                        var $ul = self.$menu.find("ul");
                        $ul.empty();
                        for (var i = 0; i < json.length; i++) {
                            var $li = $('<li  data-id="' + json[i].productId + '">' + json[i].productName + '</li>');
                            $ul.append($li)
                        }

                        self.loaded();
                    }
                });
            }

            function choice(self, $li) {
                var id = $li.attr("data-id");
                var $hidden = self.$input.parent().find(".JS_autocomplete_pn1_hidden");
                $hidden.val(id);

            }
            function clearData(self) {
                var $hidden = self.$input.parent().find(".JS_autocomplete_pn1_hidden");
                $hidden.val("");
            }
        });
    })
    $(function(){
    	//查询
		$("#search_button").bind("click",function(){
			var myreg = /^(([0-9]|,)*)$/; 
			if(!myreg.test($("#productIds").val())) 
			{ 
			    alert('请输入有效的产品ID,多个ID请以逗号隔开！'); 
			    return false; 
			} 
			//加载
			loadProductList();
		});
		
		//查询
		$("#search_button1").bind("click",function(){
			var myreg = /^(([0-9]|,)*)$/; 
			if(!myreg.test($("#productIds1").val())) 
			{ 
			    alert('请输入有效的产品ID,多个ID请以逗号隔开！'); 
			    return false; 
			} 
			//加载
			loadProductList1();
		});
	
		//加载
		function loadProductList(){
				
				$("#resultBind").empty();
				$("#resultBind").append("<div class='loading mt20' style='width:220px;margin:0px auto'><img src='../../../img/loading.gif' width='32' height='32' alt='加载中'>正在努力的加载数据中......</div>");
				 //ajax加载结果
				var $form=$("#searchForm");
				var descId = $("#search_button").attr("data-descId");
				 $("#resultBind").load($form.attr("action"),$form.serialize()+"&descId="+descId,function(){
				});
		}
		
		//加载
		function loadProductList1(){
				
				$("#resultUnBind").empty();
				$("#resultUnBind").append("<div class='loading mt20' style='width:220px;margin:0px auto'><img src='../../../img/loading.gif' width='32' height='32' alt='加载中'>正在努力的加载数据中......</div>");
				 //ajax加载结果
				var $form=$("#searchForm1");
				var descId = $("#search_button1").attr("data-descId");
				 $("#resultUnBind").load($form.attr("action"),$form.serialize()+"&descId="+descId,function(){
				});
		}
		
    })
    $(function () {
	    //主动查询所有绑定产品
	    $("#search_button").trigger("click");
    })
</script>
</body>
</html>
