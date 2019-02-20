<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>编辑股东信息</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/edit-shareholder.css" />
</head>

<body class="add-shareholder edit-basic-info">
    <div class="main">
        <p class="main-title">基本信息</p>
        <form action="/vst_admin/o2o/shareholder.do" method="post" id="dataForm">
            <dl class="clearfix">
                <dt>
                    <label for="">
                        所在地：
                    </label>
                </dt>
                <dd>
                    <div class="form-group col mr10">
                        <input maxlength="30" name="locations" type="text" class="form-control w85 mr5" />
                        <input maxlength="30" name="locations" type="text" class="form-control w85 mr5" />
                        <input maxlength="30" name="locations" type="text" class="form-control w85 mr5" />
                        <input maxlength="30" name="locations" type="text" class="form-control w85 mr5" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        股东方：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="name" maxlength="90" data-validate="{required:true}" type="text" class="form-control w200" />
                    </div>
                </dd>
                <dt>
                    <label>
                        股东方类型：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                   		<select class="form-control w210" name="sholdType">
	    					<#list sholdTypes as item> 
		                    	<option value="${item.code}" <#if sholdType?? && sholdType==item.code>selected=selected</#if> >${item.cnName}</option>
		                	</#list>
                        </select>
                    </div>
                </dd>
                <dt class="natural-person-id">
                    <label>
                        证件号码：
                    </label>
                </dt>
                <dd class="natural-person-id">
                    <div class="form-group">
                        <input type="text" maxlength="25" name="naturalPersonId" class="form-control w200"/>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        资质：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input type="text" maxlength="25" name="aptitude" class="form-control w200"/>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        备注：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input type="text" maxlength="2000" name="remarks" class="form-control w200"/>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        法定代表人：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="legalRep" maxlength="25" type="text" class="form-control w200" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        注册地址：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="registeredAddress" maxlength="120" type="text" class="form-control w200" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        经营地址：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="businessAddress" maxlength="120" type="text" class="form-control w200" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        邮编：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="zip" type="text" data-validate="{regular:仅支持输入字母数字}" data-validate-regular="^[A-Za-z0-9]{1,6}$" maxlength="6" class="form-control w200" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        公司网址：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="site" maxlength="40" type="text" class="form-control w200" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        股东状态：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                    	<select class="form-control w200" name="sholdStatus">
		                    	<option value='Y'>有效</option>
		                    	<option value='N'>无效</option>
                        </select>
                    </div>
                </dd>
            </dl>
            <div class="btn-group text-center">
            	<@mis.checkPerm permCode="5126">
                	<a class="btn btn-primary JS_btn_save">保存</a>
                </@mis.checkPerm >
            </div>
        </form>
    </div>
    <script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/vst/subcompany/edit-shareholder.js"></script>
    <script>
    $(function() {

        var $document = $(document);
        // 表单验证
        var $form = $(".main").find("form");
        var validateAdd = backstage.validate({
            $area: $form,
            REQUIRED: "不能为空",
            showError: true
        });
        validateAdd.watch();

        $("select[name='sholdType']").bind('change', function() {
            var sholdType = $(this).val();
            if(!!sholdType && sholdType.toUpperCase() != "NATURAL_PERSON") {
                $(".natural-person-id input[name='naturalPersonId']").val("");
                $(".natural-person-id").hide();
            } else {
                $(".natural-person-id").show();
            }
        });

        $document.on("click", ".JS_btn_save", function() {
            validateAdd.refresh();
            validateAdd.watch();
            validateAdd.test();
            if (validateAdd.getIsValidate()) {
            	$(".JS_btn_save").hide();
            	var loading = backstage.loading({
				    title: "系统提醒消息",
				    content: '<p><i class="icon-loading"></i>' + '正在保存中' + '</p>'
				});
                backstage.confirm({
                	content: "确定要保存么？",
                	determineCallback: function(){
						$.ajax({
							url : "/vst_admin/o2o/shareholder.do",
							type : "post",
							dataType : 'json',
							data : $("#dataForm").serialize(),
							success : function(result) {
								loading.destroy();
								if(result.code == "success"){
									//为父窗口设置productId
									$("#shareholderId",window.parent.document).val(result.attributes.shareholderId);
									$("#viewType",window.parent.document).val("WRITABLE");
									backstage.alert({
						   		  		content: result.message,
						   		  		callback: function () {
						   		  			$(".JS_btn_save").show();
						   		  		}
						   		  	});
								}else {
									backstage.alert({
						   		  		content: result.message,
						   		  		callback: function () {
						   		  			$(".JS_btn_save").show();
						   		  		}
						   		  	});
								}
							},
							error : function(){
								loading.destroy();
								$(".JS_btn_save").show();
							}
						})
					},
					cancelCallback: function(){
						loading.destroy();
						$(".JS_btn_save").show();
					}
				});
            }
        });
    });
    </script>
</body>

</html>
