const { Resend } = require('resend');

const resend = new Resend(process.env.RESEND_API_KEY);

const sendOTPEmail = async (email, otp) => {
  console.log(
    'RESEND_API_KEY:',
    process.env.RESEND_API_KEY ? 'ADA' : 'HILANG'
  );

  await resend.emails.send({
    from: process.env.EMAIL_FROM,
    to: email,
    subject: 'Kode OTP Questify',
    html: `
      <h2>Kode OTP Kamu</h2>
      <p>Gunakan kode berikut untuk verifikasi akun:</p>
      <h1>${otp}</h1>
      <p>Kode berlaku 5 menit</p>
    `,
  });
};

module.exports = { sendOTPEmail };
