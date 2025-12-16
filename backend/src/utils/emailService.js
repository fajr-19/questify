const Brevo = require('@getbrevo/brevo');

const apiInstance = new Brevo.TransactionalEmailsApi();

apiInstance.setApiKey(
  Brevo.TransactionalEmailsApiApiKeys.apiKey,
  process.env.EMAIL_API_KEY
);

exports.sendOTP = async (toEmail, otp) => {
  const sendSmtpEmail = {
    sender: {
      email: process.env.EMAIL_FROM,
      name: process.env.EMAIL_FROM_NAME,
    },
    to: [
      {
        email: toEmail,
      },
    ],
    subject: 'Kode Verifikasi Questify',
    htmlContent: `
      <h2>Verifikasi Akun Questify</h2>
      <p>Kode OTP kamu:</p>
      <h1>${otp}</h1>
      <p>Kode berlaku selama <b>5 menit</b>.</p>
    `,
  };

  await apiInstance.sendTransacEmail(sendSmtpEmail);
};
