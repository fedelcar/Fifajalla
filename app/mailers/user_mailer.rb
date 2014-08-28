class UserMailer < ActionMailer::Base
   default :from => 'notificaciones@fifajalla.ddns.net'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def welcome_email(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'Bienvenido a FIFAjalla!' )
  end
  
  def trade_offer(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'FIFAjalla: Te hicieron una oferta!' )
  end

  def next_pick(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'FIFAjalla: Te toca elegir en el draft!' )
  end

   def trade_complete(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'FIFAjalla: Te aceptaron el trade!' )
  end


   def trade_rejected(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'FIFAjalla: Te rechazaron el trade. :(' )
  end
end
