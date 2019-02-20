
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>预览</title>
</head>
<body class="product-feature">
   
    <!--预览 开始-->
    <div class="pf-view-template JS_view_template">
    </div>
    <!--预览 结束-->

<!--公用脚本 START-->
<script src="http://pic.lvmama.com/min/index.php?f=/js/new_v/jquery-1.7.2.min.js"></script>
<!--公用脚本 END-->
<script>
	$(".JS_view_template").append($("#richTextVal" , parent.document).val());
    $(".JS_view_template").append($("#htmlForFeature" , parent.document).val());
</script>

</body>
</html>
