$(function(){
   $("#add_work").on("click",function(){
        $(".work_add:last").clone().insertAfter(".work_add:last");
        $(".work_add:last").find('input:text').val('');
   });
   $("#add_edu").on("click",function(){
        $(".edu_add:last").clone().insertAfter(".edu_add:last");
        $(".edu_add:last").find('input:text').val('');
   });

    $("#share").click(function(){
            $.ajax({
                type: 'POST',
                url: "resumes/generate_pdf.pdf",
                data:$('form').serialize(),
                error: function(){  },
                success: function(data){
                    $('#dialog-message input').val(data);
                    $('#dialog-message').dialog();
                },
                complete: function (){   }
            });
            return false;
        });
});